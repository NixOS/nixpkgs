{
  stdenv,
  lib,
  transmission_4,
  fetchurl,
  _7zz,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "transmission_4-bin";
  version = "4.0.6";

  src = fetchurl {
    url = "https://github.com/transmission/transmission/releases/download/${finalAttrs.version}/Transmission-${finalAttrs.version}.dmg";
    hash = "sha256-5phX8VLgwvU4TMYDWGw9/ywwyT5nQmM0anAoY+cnfBo=";
  };
  sourceRoot = ".";

  nativeBuildInputs = [ _7zz ];

  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r Transmission/Transmission.app $out/Applications

    runHook postInstall
  '';

  meta =
    transmission_4.meta
    // (with lib; {
      maintainers = with maintainers; [ fbettag ];
      platforms = platforms.darwin;
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    });
})
