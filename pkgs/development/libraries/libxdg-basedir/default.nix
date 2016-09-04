{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "libxdg-basedir-1.0.2";
  src = fetchurl {
    url = "http://n.ethz.ch/student/nevillm/download/libxdg-basedir/${name}.tar.gz";
    sha256 = "0fibbzba228gdk05lfi8cgfrsp80a2gnjbwka0pzpkig0fz8pp9i";
  };

  meta = {
    homepage = http://n.ethz.ch/student/nevillm/download/libxdg-basedir/;
    description = "Implementation of the XDG Base Directory specification";
    license = "BSD";
    platforms = stdenv.lib.platforms.unix;
  };
}
