{ stdenv, fetchurl, pkgconfig, glib, pango, libX11 }:

stdenv.mkDerivation rec {
  pname = "pangox-compat";
  version = "0.0.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0ip0ziys6mrqqmz4n71ays0kf5cs1xflj1gfpvs4fgy2nsrr482m";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib pango libX11 ];

  meta = {
    description = "A compatibility library for pango>1.30.*";
    homepage = "https://gitlab.gnome.org/Archive/pangox-compat";
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
