{ lib, stdenv, fetchurl, intltool }:

stdenv.mkDerivation rec {
  pname = "lxmenu-data";
  version = "0.1.5";

  src = fetchurl {
    url = "mirror://sourceforge/lxde/${pname}-${version}.tar.xz";
    sha256 = "9fe3218d2ef50b91190162f4f923d6524c364849f87bcda8b4ed8eb59b80bab8";
  };

  buildInputs = [ intltool ];

  meta = {
    homepage = "https://lxde.org/";
    license = lib.licenses.gpl2;
    description = "Freedesktop.org desktop menus for LXDE";
    platforms = lib.platforms.linux;
  };
}
