{ stdenv
, buildGo121Module
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
  version = "2.37.2";
  zitadelRepo = fetchFromGitHub {
    owner = "zitadel";
    repo = "zitadel";
    rev = "v${version}";
    hash = "sha256-iWEL7R7eNDV4c1CZhmxxiHHI9ExwU6gnmHI6ildaXWY=";
  };
  goModulesHash = "sha256-lk4jEiI85EKk0G4JCHvCazqBBTfiNJqSfzvrJgDZ1Nc=";

  buildZitadelProtocGen = name:
    buildGo121Module {
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

      nativeBuildInputs = nativeBuildInputs ++ [ buf ];

      buildPhase = ''
        cd ${workDir}
        export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
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
    hash = "sha256-+9UFBWBuSYNbfimKwJUSoiUh+8bDHGnPdx1MKDul1U4=";
  };
in
buildGo121Module rec {
  name = "zitadel";
  inherit version;

  src = zitadelRepo;

  nativeBuildInputs = [ sass statik ];

  proxyVendor = true;
  vendorHash = goModulesHash;

  # Adapted from Makefile in repo, with dependency fetching and protobuf codegen
  # bits removed
  buildPhase = ''
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
    CGO_ENABLED=0 go build -o zitadel -v -ldflags="-s -w -X 'github.com/zitadel/zitadel/cmd/build.version=${version}'"
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 zitadel $out/bin/
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
    maintainers = with maintainers; [ Sorixelle ];
  };
}
