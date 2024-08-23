{ generateProtobufCode
, version
, zitadelRepo
}:

{ mkYarnPackage
, fetchYarnDeps
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
    hash = "sha256-n6BJ1gSSm66yOGdHcSea/nQbjiHZX2YX2zbFT4o75/4=";
  };
in
mkYarnPackage rec {
  name = "zitadel-console";
  inherit version;

  src = "${zitadelRepo}/console";

  packageJSON = ./package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-MWATjfhIbo3cqpzOdXP52f/0Td60n99OTU1Qk6oWmXU=";
  };

  postPatch = ''
    substituteInPlace src/styles.scss \
      --replace-fail "/node_modules/flag-icons" "flag-icons"

    substituteInPlace angular.json \
      --replace-fail "./node_modules/tinycolor2" "../../node_modules/tinycolor2"
  '';

  buildPhase = ''
    ln -s "${zitadelRepo}/docs" deps/docs
    mkdir deps/console/src/app/proto
    cp -r ${protobufGenerated}/* deps/console/src/app/proto/
    yarn --offline build
  '';

  installPhase = ''
    cp -r deps/console/dist/console $out
  '';

  doDist = false;
}
