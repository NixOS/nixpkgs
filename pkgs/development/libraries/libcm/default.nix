{stdenv, fetchurl, pkgconfig, glib, xlibs, mesa}:

stdenv.mkDerivation {
  name = "libcm-0.1.1";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/sources/libcm/0.1/libcm-0.1.1.tar.bz2;
    sha256 = "11i5z8l5v5ffihif35k5j8igj0rahsk4jdmsj24xhdw2s0zx53kn";
  };
  buildInputs = [
    pkgconfig glib xlibs.xlibs xlibs.libXdamage xlibs.libXcomposite
    xlibs.libXtst xlibs.inputproto
    # !!! inputproto should really be propagated by libXtst
  ];
  propagatedBuildInputs = [mesa];
}
