{
  stdenv,
  lib,
  undmg,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "Unclack";
  version = "1.3.0";

  src = fetchurl {
    name = "Unclack.dmg";
    url = "https://unclack.app/app/${version}/Unclack.dmg";
    hash = "sha256-aNmpbNO31thcty4rQUzQl7KHzDbSdcjJB49zdmx4Kjs=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -R Unclack.app $out/Applications
    runHook postInstall
  '';

  meta = {
    description = "Unclack is the small but mighty Mac utility that mutes your microphone while you type.";
    homepage = "https://unclack.app";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "Unclack.app";
    maintainers = with lib.maintainers; [ yamashitax ];
    platforms = lib.platforms.darwin;
  };
}
