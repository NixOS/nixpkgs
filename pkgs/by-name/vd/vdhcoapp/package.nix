{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs,
  ffmpeg,
  callPackage,
  substituteAll,
  makeWrapper,
  toml2json,
  jq,
}:
buildNpmPackage rec {
  pname = "vdhcoapp";
  version = "2.0.19";

  src = fetchFromGitHub {
    owner = "aclap-dev";
    repo = "vdhcoapp";
    rev = "v${version}";
    hash = "sha256-8xeZvqpRq71aShVogiwlVD3gQoPGseNOmz5E3KbsZxU=";
  };

  sourceRoot = "${src.name}/app";
  npmDepsHash = "sha256-E032U2XZdyTER6ROkBosOTn7bweDXHl8voC3BQEz8Wg=";
  dontNpmBuild = true;

  nativeBuildInputs = [
    makeWrapper
    toml2json
    jq
  ];

  patches = [
    (substituteAll {
      src = ./ffmpeg-filepicker.patch;
      inherit ffmpeg;
      filepicker = lib.getExe (callPackage ./filepicker.nix { });
    })
  ];

  postPatch = ''
    # Cannot use patch, setting placeholder here
    substituteInPlace src/native-autoinstall.js \
      --replace process.execPath "\"${placeholder "out"}/bin/vdhcoapp\""
  '';

  preBuild = ''
    toml2json --pretty ../config.toml > src/config.json
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/opt/vdhcoapp
    cp -r . "$out/opt/vdhcoapp"

    makeWrapper ${nodejs}/bin/node $out/bin/vdhcoapp \
      --add-flags $out/opt/vdhcoapp/src/main.js

    generateManifest() {
      type=$1
      outputFolder=$2
      mkdir -p $outputFolder
      manifestName=$(jq -r '.meta.id' src/config.json).json
      jq '.store.'$type'.manifest * (.meta | with_entries(select (.key == "description")) * {"name": .id}) * {"path" : "${placeholder "out"}/bin/vdhcoapp"}' src/config.json > $outputFolder/$manifestName
    }

    generateManifest google $out/etc/opt/chrome/native-messaging-hosts
    generateManifest google $out/etc/chromium/native-messaging-hosts
    generateManifest mozilla $out/lib/mozilla/native-messaging-hosts
    generateManifest google $out/etc/opt/edge/native-messaging-hosts

    runHook postInstall
  '';

  meta = with lib; {
    description = "Companion application for the Video DownloadHelper browser add-on";
    homepage = "https://www.downloadhelper.net/";
    license = licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with maintainers; [ hannesgith ];
    mainProgram = "vdhcoapp";
  };
}
