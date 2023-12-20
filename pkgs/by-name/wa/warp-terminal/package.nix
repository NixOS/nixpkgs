{ lib
, stdenvNoCC
, fetchurl
, undmg
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "warp-terminal";
  version = "0.2023.12.05.08.02.stable_00";

  src = fetchurl {
    url = "https://releases.warp.dev/stable/v${finalAttrs.version}/Warp.dmg";
    hash = "sha256-9olAmczIPRXV15NYCOYmwuEmJ7lMeaQRTTfukaYXMR0=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  meta = with lib; {
    description = "Rust-based terminal";
    homepage = "https://www.warp.dev";
    license = licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ emilytrau Enzime ];
    platforms = platforms.darwin;
  };
})
