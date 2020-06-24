{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "overpass";
  version = "3.0.4";

  src = fetchzip {
    url = "https://github.com/RedHatBrand/Overpass/archive/${version}.zip";
    sha256 = "1pl7zpwlx0j2xv23ahnpmbb4a5d6ib2cjck5mxqzi3jjk25rk9kb";
  };

  meta = with lib; {
    homepage = "https://overpassfont.org/";
    description = "Font heavily inspired by Highway Gothic";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
