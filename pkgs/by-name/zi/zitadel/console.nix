{
  generateProtobufCode,
  jsDeps,
  version,
  zitadelRepo,
}:

{
  lib,
  stdenv,

  grpc-gateway,
  nodejs,
  pnpmConfigHook,
  protoc-gen-grpc-web,
  protoc-gen-js,
}:

let
  # Upstream generates this from console/ with
  # `buf generate ../proto --include-imports --include-wkt` (the `generate`
  # target in console/project.json). Here the same generators run against
  # protoImage instead of the proto tree.
  consoleProtobufGenerated = generateProtobufCode {
    pname = "zitadel-console";
    inherit version;
    nativeBuildInputs = [
      grpc-gateway
      protoc-gen-grpc-web
      protoc-gen-js
    ];
    workDir = "console";
    bufArgs = "--include-imports --include-wkt";
    outputPath = "src/app/proto/generated";
  };
in
stdenv.mkDerivation {
  pname = "zitadel-console";
  inherit version;

  src = zitadelRepo;

  inherit (jsDeps) pnpmDeps;
  pnpmWorkspaces = [
    "@zitadel/client"
    "@zitadel/console"
    "@zitadel/proto"
  ];

  nativeBuildInputs = [
    nodejs
    jsDeps.pnpm
    pnpmConfigHook
  ];

  env.NODE_OPTIONS = "--max-old-space-size=8192";

  preBuild = ''
    cp -r ${jsDeps.protoPackageGenerated}/* packages/zitadel-proto/
    mkdir -p console/src/app/proto
    cp -r ${consoleProtobufGenerated} console/src/app/proto/generated
    chmod -R u+w packages/zitadel-proto console/src/app/proto
  '';

  # console/project.json's `build` target resolves to the same-named script in
  # console/package.json; nx.json's targetDefaults make it depend on the
  # workspace packages' builds first.
  buildPhase = ''
    runHook preBuild

    pushd packages/zitadel-client
    pnpm run build
    popd

    pushd console
    pnpm run build
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    cp -r console/dist/console "$out"
    runHook postInstall
  '';

  meta = {
    description = "Management console for the ZITADEL identity and access management platform";
    homepage = "https://zitadel.com/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
