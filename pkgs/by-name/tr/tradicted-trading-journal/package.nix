{
  lib,
  appimageTools,
  fetchurl,
}:

appimageTools.wrapType2 {
  pname = "tradicted-trading-journal";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/tradicted/tradicted-journal/releases/download/v1.0.0/tradicted-trading-journal-1.0.0.AppImage";
    hash = "sha256-OzGwDiFrC4vdX+b1BBg5RQXyNW9ejlPFpODnoYEkt0g=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Free open-source desktop trading journal by Tradicted";
    homepage = "https://www.tradicted.com";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
