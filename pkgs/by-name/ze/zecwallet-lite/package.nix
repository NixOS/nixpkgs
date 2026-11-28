{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "zecwallet-lite";
  version = "1.8.8";

  src = fetchurl {
    url = "https://github.com/adityapk00/zecwallet-lite/releases/download/v${finalAttrs.version}/Zecwallet.Lite-${finalAttrs.version}.AppImage";
    hash = "sha256-6jppP3V7R8tCR5Wv5UWfbWKkAdsgrCjSiO/bbpLNcw4=";
  };

  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/zecwallet-lite.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/zecwallet-lite.desktop \
      --replace 'Exec=AppRun' "Exec=$out/bin/zecwallet-lite"
    cp -r ${finalAttrs.contents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Fully featured shielded wallet for Zcash";
    homepage = "https://www.zecwallet.co/";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "zecwallet-lite";
  };
})
