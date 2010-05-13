{ stdenv, fetchurl, glib, flex, bison, pkgconfig, libffi, python, cairo }:

let
  baseName = "gobject-introspection";
  v = "0.6.10";
in

stdenv.mkDerivation rec {
  name = "${baseName}-${v}";

  buildInputs = [ flex bison glib pkgconfig python cairo ];
  propagatedBuildInputs = [ libffi ];
  configureFlags = "--enable-gcov";

  src = fetchurl {
    url = "mirror://gnome/sources/${baseName}/0.6/${name}.tar.bz2";
    sha256 = "0jwd7bybgvg6dwhg64da8k9yjrs37y5p153gaaapz5j59ld53g9n";
  };

  meta = with stdenv.lib; {
    maintainers = [ maintainers.urkud ];
    platforms = [ platforms.linux ];
    homepage = http://live.gnome.org/GObjectIntrospection;
  };
}
