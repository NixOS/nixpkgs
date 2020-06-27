{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "hasklig";
  version = "1.1";

  src = fetchzip {
    url = "https://github.com/i-tu/Hasklig/releases/download/${version}/Hasklig-${version}.zip";
    sha256 = "0jmjgy3y5sj6d8nqq1ap5hnpkbcsgpbdahcbny7wg04y7fvd1hwf";
    stripRoot = false;
  };

  meta = with lib; {
    homepage = "https://github.com/i-tu/Hasklig";
    description = "A font with ligatures for Haskell code based off Source Code Pro";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ davidrusu Profpatsch ];
  };
}
