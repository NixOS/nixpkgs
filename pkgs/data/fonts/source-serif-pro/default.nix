{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "source-serif-pro";
  version = "3.000";

  src = fetchzip {
    url = "https://github.com/adobe-fonts/source-serif-pro/releases/download/${version}R/source-serif-pro-${version}R.zip";
    sha256 = "1l0bcb6czlrm6raldlvr3aq1rz8l1c83dqqv1pavgc5yc15c239j";
    stripRoot = false;
  };

  meta = with lib; {
    homepage = "https://adobe-fonts.github.io/source-serif-pro/";
    description = "A set of OpenType fonts to complement Source Sans Pro";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}

