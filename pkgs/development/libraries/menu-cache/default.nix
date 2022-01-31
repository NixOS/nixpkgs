{ lib, stdenv, fetchurl, glib, pkg-config, libfm-extra }:

stdenv.mkDerivation rec {
  pname = "menu-cache";
  version = "1.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/lxde/menu-cache-${version}.tar.xz";
    sha256 = "1iry4zlpppww8qai2cw4zid4081hh7fz8nzsp5lqyffbkm2yn0pd";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ glib libfm-extra ];

  meta = with lib; {
    description = "Library to read freedesktop.org menu files";
    homepage = "https://blog.lxde.org/tag/menu-cache/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
