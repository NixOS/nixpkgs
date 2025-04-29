{
  generateProtobufCode,
  version,
  zitadelRepo,
}:

{
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
    hash = "sha256-UzmwUUYg0my3noAQNtlUEBQ+K6GVnBSkWj4CzoaoLKw=";
  };
in
stdenv.mkDerivation {
  pname = "zitadel-console";
  inherit version;

  src = zitadelRepo;

  sourceRoot = "${zitadelRepo.name}/console";

  offlineCache = fetchYarnDeps {
    yarnLock = "${zitadelRepo}/console/yarn.lock";
    hash = "sha256-ekgLd5DTOBZWuT63QnTjx40ZYvLKZh+FXCn+h5vj9qQ=";
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
