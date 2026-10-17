{
  stdenv,
  buildGoModule,
  callPackage,
  fetchFromGitHub,
  lib,

  buf,
  cacert,
  dart-sass,
  grpc-gateway,
  protoc-gen-connect-go,
  protoc-gen-go,
  protoc-gen-go-grpc,
  protoc-gen-validate,
  statik,
}:

let
  version = "4.17.3";
  zitadelRepo = fetchFromGitHub {
    owner = "zitadel";
    repo = "zitadel";
    tag = "v${version}";
    hash = "sha256-nA9GgsvCKFNaHjMLwb1SNNZPLL02YP8vK9oec2qVDnE=";
  };
  goModulesHash = "sha256-8/TkV1JTKNSIknzEPbTDWzcOZQ6jCEkc6vSLLhdLYrs=";

  # protoc plugins that live inside the ZITADEL repo itself. Upstream installs
  # them with `go install ./internal/protoc/...` (the `generate-install` target
  # in apps/api/project.json).
  buildZitadelProtocGen =
    name:
    buildGoModule {
      pname = "protoc-gen-${name}";
      inherit version;

      src = zitadelRepo;

      proxyVendor = true;
      vendorHash = goModulesHash;

      subPackages = [ "internal/protoc/protoc-gen-${name}" ];

      doCheck = false;
    };

  protoc-gen-authoption = buildZitadelProtocGen "authoption";
  protoc-gen-zitadel = buildZitadelProtocGen "zitadel";

  # proto/buf.lock pins dependencies that buf resolves from the Buf Schema
  # Registry, so building a descriptor set out of the workspace needs network
  # access. That fetch is the only step that does: it goes into a fixed-output
  # derivation, and the code generators below then run offline against the
  # resulting image as ordinary derivations.
  #
  # $out is the image file itself and carries no `.binpb` suffix, so every
  # `buf generate` below has to name its format explicitly.
  protoImage = stdenv.mkDerivation {
    pname = "zitadel-proto-image";
    inherit version;

    src = zitadelRepo;

    nativeBuildInputs = [
      buf
      cacert
    ];

    buildPhase = ''
      runHook preBuild
      HOME=$TMPDIR buf build proto -o image.binpb
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp image.binpb $out
      runHook postInstall
    '';

    outputHashMode = "flat";
    outputHash = "sha256-FkrbbUWvzziOe/mb3f3BgoApPLMQZPR07+EA8UMGY2g=";
  };

  generateProtobufCode =
    {
      pname,
      version,
      nativeBuildInputs ? [ ],
      bufArgs ? "",
      workDir ? ".",
      outputPath,
    }:
    stdenv.mkDerivation {
      pname = "${pname}-buf-generated";
      inherit version;

      src = zitadelRepo;

      nativeBuildInputs = nativeBuildInputs ++ [ buf ];

      buildPhase = ''
        runHook preBuild
        cd ${workDir}
        HOME=$TMPDIR buf generate ${protoImage}#format=binpb ${bufArgs}
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        cp -r ${outputPath} $out
        runHook postInstall
      '';
    };

  # pnpm store and the protobuf-es codegen for the console
  jsDeps = callPackage ./javascript.nix { inherit protoImage version zitadelRepo; };

  # Upstream runs `buf generate` from the repository root (the `generate-stubs`
  # target in apps/api/project.json); here it runs against protoImage.
  protobufGenerated = generateProtobufCode {
    pname = "zitadel";
    inherit version;
    nativeBuildInputs = [
      grpc-gateway
      protoc-gen-authoption
      protoc-gen-connect-go
      protoc-gen-go
      protoc-gen-go-grpc
      protoc-gen-validate
      protoc-gen-zitadel
    ];
    outputPath = ".artifacts";
  };
in
buildGoModule (finalAttrs: {
  pname = "zitadel";
  inherit version;

  src = zitadelRepo;

  nativeBuildInputs = [
    dart-sass
    statik
  ];

  # The upstream //go:generate directive shells out to `pnpm sass`; we provide
  # dart-sass directly instead of going through the JS toolchain.
  postPatch = ''
    substituteInPlace internal/api/ui/login/static/resources/generate.go \
      --replace-fail "pnpm sass" "sass"
  '';

  proxyVendor = true;
  vendorHash = goModulesHash;
  ldflags = [
    "-s"
    "-w"
    "-X 'github.com/zitadel/zitadel/cmd/build.version=${version}'"
  ];

  # The repository also contains documentation snippets and test helpers that
  # are not part of the main module; only the root package is the server.
  subPackages = [ "." ];

  # Adapted from apps/api/project.json (targets: generate-stubs, generate-statik,
  # generate-assets, build-console), with dependency fetching and protobuf
  # codegen bits removed.
  preBuild = ''
    # ZITADEL warns on every invocation if the build date is unset, so derive a
    # deterministic one from SOURCE_DATE_EPOCH.
    ldflags+=" -X github.com/zitadel/zitadel/cmd/build.date=$(date -u -d "@$SOURCE_DATE_EPOCH" +%Y-%m-%dT%H:%M:%SZ)"

    mkdir -p pkg/grpc
    cp -r ${protobufGenerated}/grpc/github.com/zitadel/zitadel/pkg/grpc/* pkg/grpc
    mkdir -p openapi/v2/zitadel
    cp -r ${protobufGenerated}/grpc/zitadel/ openapi/v2/zitadel

    go generate internal/api/ui/login/static/resources/generate.go
    go generate internal/api/ui/login/statik/generate.go
    go generate internal/notification/statik/generate.go
    go generate internal/statik/generate.go

    mkdir -p apps/docs/content/apis/assets
    go run internal/api/assets/generator/asset_generator.go \
      -directory=internal/api/assets/generator/ \
      -assets=apps/docs/content/apis/assets/assets.mdx

    find internal/api/ui/console/static -mindepth 1 ! -name gitkeep -delete
    cp -r ${finalAttrs.passthru.console}/* internal/api/ui/console/static
  '';

  doCheck = false;

  installPhase = ''
    runHook preInstall
    install -Dm755 $GOPATH/bin/zitadel $out/bin/zitadel
    runHook postInstall
  '';

  passthru = {
    console = callPackage (import ./console.nix {
      inherit
        generateProtobufCode
        jsDeps
        version
        zitadelRepo
        ;
    }) { };

    # zitadel-login builds from the same source and needs the same generated
    # packages/zitadel-proto, but neither the API server nor the console.
    inherit (jsDeps) protoPackageGenerated;
  };

  meta = {
    description = "Identity and access management platform";
    homepage = "https://zitadel.com/";
    downloadPage = "https://github.com/zitadel/zitadel/releases";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    # v2.71.7 was Apache-2.0; v3.0.0 relicensed to AGPL-3.0-only
    # (LICENSING.md, https://zitadel.com/blog/apache-to-agpl).
    license = lib.licenses.agpl3Only;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = with lib.maintainers; [
      nrabulinski
      byteflavour
    ];
    mainProgram = "zitadel";
  };
})
