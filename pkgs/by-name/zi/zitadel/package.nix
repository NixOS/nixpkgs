{ stdenv
, buildGoModule
, callPackage
, fetchFromGitHub
, lib

, buf
, cacert
, grpc-gateway
, protoc-gen-go
, protoc-gen-go-grpc
, protoc-gen-validate
, sass
, statik
}:

let
  version = "2.58.3";
  zitadelRepo = fetchFromGitHub {
    owner = "zitadel";
    repo = "zitadel";
    rev = "v${version}";
    hash = "sha256-RXcJwGO8OQ38lbuy2uLTSkh6yUbyqY42FpwgMXC3g6c=";
  };
  goModulesHash = "sha256-gp17dP67HX7Tx3Gq+kEu9xCYkfs/rGpqLFiKT7cKlrc=";

  buildZitadelProtocGen = name:
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

  # Buf downloads dependencies from an external repo - there doesn't seem to
  # really be any good way around it. We'll use a fixed-output derivation so it
  # can download what it needs, and output the relevant generated code for use
  # during the main build.
  generateProtobufCode =
    { pname
    , nativeBuildInputs ? [ ]
    , bufArgs ? ""
    , workDir ? "."
    , outputPath
    , hash
    }:
    stdenv.mkDerivation {
      name = "${pname}-buf-generated";

      src = zitadelRepo;
      patches = [ ./console-use-local-protobuf-plugins.patch ];

      nativeBuildInputs = nativeBuildInputs ++ [ buf cacert ];

      buildPhase = ''
        cd ${workDir}
        HOME=$TMPDIR buf generate ${bufArgs}
      '';

      installPhase = ''
        cp -r ${outputPath} $out
      '';

      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = hash;
    };

  protobufGenerated = generateProtobufCode {
    pname = "zitadel";
    nativeBuildInputs = [
      grpc-gateway
      protoc-gen-authoption
      protoc-gen-go
      protoc-gen-go-grpc
      protoc-gen-validate
      protoc-gen-zitadel
    ];
    outputPath = ".artifacts";
    hash = "sha256-KRf11PNn7LtVFjG3NYUtPEJtLNbnxfzR4B69US07B3k=";
  };
in
buildGoModule rec {
  name = "zitadel";
  inherit version;

  src = zitadelRepo;

  nativeBuildInputs = [ sass statik ];

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
    console = callPackage
      (import ./console.nix {
        inherit generateProtobufCode version zitadelRepo;
      })
      { };
  };

  meta = with lib; {
    description = "Identity and access management platform";
    homepage = "https://zitadel.com/";
    downloadPage = "https://github.com/zitadel/zitadel/releases";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.asl20;
    sourceProvenance = [ sourceTypes.fromSource ];
    maintainers = [ maintainers.nrabulinski ];
  };
}
