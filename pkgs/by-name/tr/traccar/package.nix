{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  makeWrapper,
  npmHooks,
  gradle,
  nix-update-script,
  nodejs,
  openjdk,
  protobuf,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "traccar";
  version = "6.13.2";

  src = fetchFromGitHub {
    owner = "traccar";
    repo = "traccar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PqveNJlONxjmTu8YikEa+6X0nJddvW4jbz1RieM6j/Y=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    makeWrapper
    npmHooks.npmConfigHook
    gradle
    nodejs
  ];

  patches = [ ./use-protobuf-from-nixpkgs.patch ];

  postPatch = ''
    substituteAllInPlace build.gradle
  '';

  env.protocPath = lib.getExe' protobuf "protoc";

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  npmRoot = "traccar-web";

  npmDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/traccar-web";
    hash = "sha256-ghU+Y+TSD/mpFb13epYgxlkkWY/UAWmBsILXaecAig8=";
  };

  preBuild = ''
    pushd traccar-web
    npm run build
    popd
  '';

  gradleBuildTask = "build";

  doCheck = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -r {schema,target/*,templates} $out
    cp -r traccar-web/build $out/web
    cp -r traccar-web/src/resources/l10n $out/templates/translations
    makeWrapper ${openjdk}/bin/java $out/bin/traccar \
      --add-flags "-jar $out/tracker-server.jar"
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open source GPS tracking system";
    homepage = "https://www.traccar.org/";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      fromSource
    ];
    license = lib.licenses.asl20;
    mainProgram = "traccar";
    maintainers = with lib.maintainers; [ frederictobiasc ];
  };
})
