{
  stdenv,
  fetchurl,
  undmg,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "thorium";
  version = "126.0.6478.231";

  src = fetchurl {
    url = "https://github.com/Alex313031/Thorium-MacOS/releases/download/M${finalAttrs.version}/Thorium_MacOS_ARM64.dmg";
    hash = "sha256-BBqkNbQ7QjCMfU8yQkiRqV3g9ipjco1XKxR7VYVWhig=";
  };

  nativeBuildInputs = [ undmg ];

  unpackPhase = ''
    runHook preUnpack
    undmg "$src"
    rm ./Applications
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -r ./Thorium.app $out/Applications

    mkdir -p "$out/bin"
    ln -sr "$out/Applications/Thorium.app/Contents/MacOS/Thorium" "$out/bin/thorium"

    runHook postInstall
  '';

  meta = {
    description = "Chromium fork for Linux, Windows, MacOS, Android, and Raspberry Pi named after radioactive element No. 90.";
    homepage = "https://thorium.rocks/";
    license = lib.licenses.bsd3;
    mainProgram = "thorium";
    maintainers = [ lib.maintainers.quinneden ];
    platforms = [ "aarch64-darwin" ]; # Upstream issue with building on x86_64-darwin, latest version only aarch64-darwin currently.
    # undmg has a problem reading the dmg file during the unpack phase on systems other than aarch64-darwin.
    # TODO: another way to unpack with this dependency?
    badPlatforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})
