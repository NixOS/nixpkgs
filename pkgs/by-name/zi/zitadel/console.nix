{ generateProtobufCode
, version
, zitadelRepo
}:

{ mkYarnPackage
, fetchYarnDeps
, lib
}:

let
  protobufGenerated = generateProtobufCode {
    pname = "zitadel-console";
    workDir = "console";
    bufArgs = "../proto --include-imports --include-wkt";
    outputPath = "src/app/proto";
    hash = "sha256-s0dzmcjKd8ot7t+KlRlNVA9oiIDKVMnGOT/HjdaUjGI=";
  };
in
mkYarnPackage rec {
  name = "zitadel-console";
  inherit version;

  src = "${zitadelRepo}/console";

  packageJSON = ./package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-48IC4LxqbkH+95k7rCmhRWT+qAlJ9CDXWwRjbric9no=";
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
