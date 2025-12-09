{
  stdenv,
  buildGoModule,
  callPackage,
  fetchFromGitHub,
  lib,

  buf,
  cacert,
  grpc-gateway,
  protoc-gen-go,
  protoc-gen-go-grpc,
  protoc-gen-validate,
  sass,
  statik,
  yq-go,
  emptyDirectory,
}:

let
  generatedSrc = builtins.fromJSON (builtins.readFile ./source.json);
  inherit (generatedSrc) version goModulesHash;
  zitadelRepo = fetchFromGitHub {
    owner = "zitadel";
    repo = "zitadel";
    rev = "v${version}";
    hash = generatedSrc.repoHash;
  };

  buildZitadelProtocGen =
    name:
    buildGoModule {
      pname = "protoc-gen-${name}";
      inherit version;

      src = zitadelRepo;

      proxyVendor = true;
      vendorHash = goModulesHash;

      buildPhase = ''
        go install internal/protoc/protoc-gen-${name}/main.go
      '';

      postInstall = ''
        mv $out/bin/main $out/bin/protoc-gen-${name}
      '';
    };

  protoc-gen-authoption = buildZitadelProtocGen "authoption";
  protoc-gen-zitadel = buildZitadelProtocGen "zitadel";

  fetchProtobufDep =
    {
      remote,
      owner,
      repository,
      commit,
      hash,
    }:
    stdenv.mkDerivation {
      pname = "${repository}-buf-dep";
      version = commit;

      src = emptyDirectory;

      nativeBuildInputs = [
        buf
        cacert
      ];

      buildPhase = ''
        env HOME=$TMPDIR buf export --output=$out ${lib.escapeShellArg "${remote}/${owner}/${repository}:${commit}"}
      '';

      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = hash;
    };

  # Buf downloads dependencies from an external repo - there doesn't seem to
  # really be any good way around it. We'll use a fixed-output derivation so it
  # can download what it needs, and output the relevant generated code for use
  # during the main build.
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
      patches = [ ./console-use-local-protobuf-plugins.patch ];

      nativeBuildInputs = nativeBuildInputs ++ [
        buf
        cacert
        yq-go
      ];

      protobufReplacements = builtins.toJSON (builtins.attrNames generatedSrc.protobufDeps);
      passAsFile = [ "protobufReplacements" ];

      buildPhase = ''
        runHook preBuild

        yq --inplace '.deps = []' proto/buf.yaml
        yq --inplace '.deps = []' proto/buf.lock
        yq eval-all --inplace '[ select(fileIndex == 0),select(fileIndex == 1) ] | .[0].directories += .[1] | .[0]' buf.work.yaml $protobufReplacementsPath
        ${lib.concatLines (
          lib.flip lib.mapAttrsToList generatedSrc.protobufDeps (
            name: dep: "ln -s ${fetchProtobufDep dep} ${name}"
          )
        )}
        cd ${workDir}
        env HOME=$TMPDIR buf generate --debug ${bufArgs}

        runHook postBuild
      '';

      installPhase = ''
        cp -r ${outputPath} $out
      '';
    };

  protobufGenerated = generateProtobufCode {
    pname = "zitadel";
    inherit version;
    nativeBuildInputs = [
      grpc-gateway
      protoc-gen-authoption
      protoc-gen-go
      protoc-gen-go-grpc
      protoc-gen-validate
      protoc-gen-zitadel
    ];
    outputPath = ".artifacts";
  };
in
buildGoModule rec {
  pname = "zitadel";
  inherit version;

  src = zitadelRepo;

  nativeBuildInputs = [
    sass
    statik
  ];

  proxyVendor = true;
  vendorHash = goModulesHash;
  ldflags = [ "-X 'github.com/zitadel/zitadel/cmd/build.version=${version}'" ];

  # Adapted from Makefile in repo, with dependency fetching and protobuf codegen
  # bits removed
  preBuild = ''
    mkdir -p pkg/grpc
    cp -r ${protobufGenerated}/grpc/github.com/zitadel/zitadel/pkg/grpc/* pkg/grpc
    mkdir -p openapi/v2/zitadel
    cp -r ${protobufGenerated}/grpc/zitadel/ openapi/v2/zitadel

    go generate internal/api/ui/login/static/resources/generate.go
    go generate internal/api/ui/login/statik/generate.go
    go generate internal/notification/statik/generate.go
    go generate internal/statik/generate.go

    mkdir -p docs/apis/assets
    go run internal/api/assets/generator/asset_generator.go -directory=internal/api/assets/generator/ -assets=docs/apis/assets/assets.md

    cp -r ${passthru.console}/* internal/api/ui/console/static
  '';

  doCheck = false;

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 $GOPATH/bin/zitadel $out/bin/
  '';

  passthru = {
    inherit fetchProtobufDep;
    console = callPackage (import ./console.nix {
      inherit generateProtobufCode version zitadelRepo;
    }) { };
    updateScript = ./update.py;
  };

  meta = {
    description = "Identity and access management platform";
    homepage = "https://zitadel.com/";
    downloadPage = "https://github.com/zitadel/zitadel/releases";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = builtins.attrValues {
      inherit (lib.maintainers)
        nrabulinski
        benaryorg
        ;
    };
  };
}
