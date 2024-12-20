{
  stdenv,
  fetchurl,
  undmg,
  lib,
}:
stdenv.mkDerivation (finalAttrs: rec {
  pname = "thorium";
  version = "M126.0.6478.231";

  src = fetchurl {
    url = "https://github.com/Alex313031/Thorium-MacOS/releases/download/M126.0.6478.231/Thorium_MacOS_ARM64.dmg";
    hash = "sha256-BBqkNbQ7QjCMfU8yQkiRqV3g9ipjco1XKxR7VYVWhig=";
  };

  nativeBuildInputs = [ undmg ];

  unpackPhase = ''
    runHook preUnpack
    undmg ${src}
    rm ./Applications
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r ./Thorium.app $out/Applications
    runHook postInstall
  '';

  meta = {
    description = "Chromium fork for Linux, Windows, MacOS, Android, and Raspberry Pi named after radioactive element No. 90.";
    homepage = "https://thorium.rocks/";
    license = lib.licenses.bsd3;
    mainProgram = "thorium";
    maintainers = [ lib.maintainers.quinneden ];
    platforms = [ "aarch64-darwin" ];
  };
})
