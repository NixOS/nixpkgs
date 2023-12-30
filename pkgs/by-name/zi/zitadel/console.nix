{ generateProtobufCode
, version
, zitadelRepo
}:

{ mkYarnPackage
, fetchYarnDeps
, lib

, grpc-gateway
, protoc-gen-grpc-web
, protoc-gen-js
}:

let
  protobufGenerated = generateProtobufCode {
    pname = "zitadel-console";
    nativeBuildInputs = [
      grpc-gateway
      protoc-gen-grpc-web
      protoc-gen-js
    ];
    workDir = "console";
    bufArgs = "../proto --include-imports --include-wkt";
    outputPath = "src/app/proto";
    hash = "sha256-Bpoe1UZGLTxUqdLbvOod6/77R4CsYQ4PirMfqvI9Lz8=";
  };
in
mkYarnPackage rec {
  name = "zitadel-console";
  inherit version;

  src = "${zitadelRepo}/console";

  packageJSON = ./package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-rSKoIznYVDNgrBmut7YSxNhgPJnbIeO+/s0HnrYWPUc=";
  };

  postPatch = ''
    substituteInPlace src/styles.scss \
      --replace "/node_modules/flag-icons" "flag-icons"

    substituteInPlace angular.json \
      --replace "./node_modules/tinycolor2" "../../node_modules/tinycolor2"
  '';

  buildPhase = ''
    mkdir deps/console/src/app/proto
    cp -r ${protobufGenerated}/* deps/console/src/app/proto/
    yarn --offline build
  '';

  installPhase = ''
    cp -r deps/console/dist/console $out
  '';

  doDist = false;
}
