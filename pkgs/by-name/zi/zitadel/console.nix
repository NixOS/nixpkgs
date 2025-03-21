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
    inherit version;
    nativeBuildInputs = [
      grpc-gateway
      protoc-gen-grpc-web
      protoc-gen-js
    ];
    workDir = "console";
    bufArgs = "../proto --include-imports --include-wkt";
    outputPath = "src/app/proto";
    hash = "sha256-3WvfbhLpp03yP7Nb8bmZXYSlGJuEnBkBuyEzNVkIYZg=";
  };
in
stdenv.mkDerivation {
  pname = "zitadel-console";
  inherit version;

  src = zitadelRepo;

  sourceRoot = "${zitadelRepo.name}/console";

  offlineCache = fetchYarnDeps {
    yarnLock = "${zitadelRepo}/console/yarn.lock";
    hash = "sha256-+7CFBEKfRsqXbJR+BkLdB+pZ/dEEk4POGwZOVQ1LAUo=";
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
