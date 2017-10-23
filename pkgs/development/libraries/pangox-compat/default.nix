{ stdenv, fetchurl, pkgconfig, glib, pango, libX11 }:

stdenv.mkDerivation rec {
  name = "pangox-compat-0.0.2";

  src = fetchurl {
    url = "mirror://gnome/sources/pangox-compat/0.0/${name}.tar.xz";
    sha256 = "0ip0ziys6mrqqmz4n71ays0kf5cs1xflj1gfpvs4fgy2nsrr482m";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib pango libX11 ];

  meta = {
    description = "A compatibility library for pango>1.30.*";

    homepage = http://www.pango.org/;
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
