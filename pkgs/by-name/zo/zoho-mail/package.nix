{ lib
, appimageTools
, fetchurl

}:
appimageTools.wrapType2  rec  {
  pname = "zoho-mail";
  version = "1.6.1";

  src = fetchurl {
    url = "https://downloads.zohocdn.com/zmail-desktop/linux/zoho-mail-desktop-lite-x64-v${version}.AppImage";
    hash = "sha256-dXl46ELcuQS4e9geNPUV0hB+LKOru9q5oCc8ar3/9Mo=";
  };
  meta = with lib; {
    description = "Zoho Mail Desktop Lite client";
    homepage = "https://www.zoho.com/mail/";
    # license = licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ imadnyc ];
    platforms = [ "x86_64-linux" ];
  };
}
