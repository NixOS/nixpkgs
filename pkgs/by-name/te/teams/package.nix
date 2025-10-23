{
  lib,
  stdenv,
  fetchurl,
  xar,
  pbzx,
  cpio,
}:

let
  pname = "teams";
  versions = {
    darwin = "25255.703.3981.5698";
  };
  hashes = {
    darwin = "sha256-p9tAvOJxoIO0d8z0qdfc4sokUNfaYKq2NtBHKOWYBM4=";
  };
  meta = with lib; {
    description = "Microsoft Teams";
    homepage = "https://teams.microsoft.com";
    downloadPage = "https://teams.microsoft.com/downloads";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ tricktron ];
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "teams";
  };
in
stdenv.mkDerivation {
  inherit pname meta;
  version = versions.darwin;

  src = fetchurl {
    url = "https://statics.teams.cdn.office.net/production-osx/${versions.darwin}/MicrosoftTeams.pkg";
    hash = hashes.darwin;
  };

  nativeBuildInputs = [
    xar
    pbzx
    cpio
  ];

  unpackPhase = ''
    xar -xf $src
  '';

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    workdir=$(pwd)
    APP_DIR=$out/Applications
    mkdir -p $APP_DIR
    cd $APP_DIR
    pbzx -n "$workdir/MicrosoftTeams_app.pkg/Payload" | cpio -idm
    runHook postInstall
  '';
}
