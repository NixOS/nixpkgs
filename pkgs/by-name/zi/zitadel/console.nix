{
  generateProtobufCode,
  version,
  zitadelRepo,
}:

{
  lib,
  stdenv,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,

  grpc-gateway,
  protoc-gen-grpc-web,
  protoc-gen-js,
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
stdenv.mkDerivation {
  pname = "zitadel-console";
  inherit version;

  src = zitadelRepo;

  sourceRoot = "${zitadelRepo.name}/console";

  offlineCache = fetchYarnDeps {
    yarnLock = "${zitadelRepo}/console/yarn.lock";
    hash = "sha256-MWATjfhIbo3cqpzOdXP52f/0Td60n99OTU1Qk6oWmXU=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
  ];

  preBuild = ''
    cp -r ${protobufGenerated} src/app/proto
  '';

  installPhase = ''
    runHook preInstall
    cp -r dist/console "$out"
    runHook postInstall
  '';
}
