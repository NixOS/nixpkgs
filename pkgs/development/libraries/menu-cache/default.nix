{ stdenv, fetchurl, glib, pkgconfig, libfm-extra }:

let name = "menu-cache-1.1.0";
in
stdenv.mkDerivation {
  inherit name;
  src = fetchurl {
    url = "mirror://sourceforge/lxde/${name}.tar.xz";
    sha256 = "1iry4zlpppww8qai2cw4zid4081hh7fz8nzsp5lqyffbkm2yn0pd";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ glib libfm-extra ];

  meta = with stdenv.lib; {
    description = "Library to read freedesktop.org menu files";
    homepage = https://blog.lxde.org/tag/menu-cache/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
