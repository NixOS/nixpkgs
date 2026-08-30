{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  makeWrapper,
  npmHooks,
  gradle_8,
  jdk_headless,
  jre_minimal,
  nodejs,
  protobuf_35,
}:
let
  jre = jre_minimal.override {
    jdk = jdk_headless;
    modules = [
      "java.desktop"
      "java.logging"
      "java.management"
      "java.naming"
      "java.sql"
      "jdk.crypto.ec"
    ];
  };
  gradle = gradle_8;
  protobuf = protobuf_35;
  protobufJavaVer = import ./protobuf-java-version.nix;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "traccar";
  version = "6.15.3";

  src = fetchFromGitHub {
    owner = "traccar";
    repo = "traccar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ic9l5WnbsCLl+THyz9LXkTGTTwyrm3gU4IPi3B362Gc=";
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
    substituteInPlace build.gradle \
      --replace-fail "\$protobufVersion" "${protobufJavaVer}"
  '';

  env.protocPath = lib.getExe' protobuf "protoc";

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  npmRoot = "traccar-web";

  npmDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/traccar-web";
    hash = "sha256-C/jfTuFFGdGNGyoYb5fhEmsKdWb5XfsoJ388Rzh35fY=";
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
    makeWrapper ${lib.getExe jre} $out/bin/traccar \
      --add-flags "-jar $out/tracker-server.jar"
    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Open source GPS tracking system";
    homepage = "https://www.traccar.org/";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      fromSource
    ];
    license = lib.licenses.asl20;
    mainProgram = "traccar";
    maintainers = with lib.maintainers; [
      frederictobiasc
      ungeskriptet
    ];
  };
})
