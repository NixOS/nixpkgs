{ fetchurl, stdenv, pkgconfig, intltool, gobject-introspection, glib, gdk_pixbuf
, libxml2, cairo, pango, gnome3 }:

stdenv.mkDerivation rec {
  pname = "lasem";
  version = "0.4.3";

  outputs = [ "bin" "out" "dev" "man" "doc" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "13ym5pm2y3wk5hh9zb2535i3lnhnzyzs0na1knxwgvwxazwm1ng7";
  };

  nativeBuildInputs = [ pkgconfig intltool gobject-introspection ];

  propagatedBuildInputs = [
    glib gdk_pixbuf libxml2 cairo pango
  ];

  enableParallelBuilding = true;
  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = {
    description = "SVG and MathML rendering library";

    homepage = https://wiki.gnome.org/Projects/Lasem;
    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.unix;
  };
}
