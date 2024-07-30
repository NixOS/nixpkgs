{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "gputils";
  version = "1.5.2";

  src = fetchurl {
    url = "mirror://sourceforge/gputils/${pname}-${version}.tar.bz2";
    sha256 = "sha256-j7iCCzHXwffHdhQcyzxPBvQK+RXaY3QSjXUtHu463fI=";
  };

  meta = with lib; {
    homepage = "https://gputils.sourceforge.io";
    description = "Collection of tools for the Microchip (TM) PIC microcontrollers. It includes gpasm, gplink, and gplib";
    license = licenses.gpl2;
    maintainers = with maintainers; [ yorickvp ];
    platforms = platforms.linux;
  };
}
