args: with args;

stdenv.mkDerivation rec {
  name = "gstreamer-" + version;

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer/${name}.tar.bz2";
    sha256 = "1ly3b6ja51vwwkdqzi20hg5azdsrz5pnhswgagdwsprb8nh8bhcl";
  };

  buildInputs = [perl bison flex pkgconfig python which  gtkdoc ];
  propagatedBuildInputs = [glib libxml2];

  configureFlags = "--enable-shared --disable-static --enable-failing-tests
    --localstatedir=/var --disable-gtk-doc --disable-docbook";

  meta = {
    homepage = http://gstreamer.freedesktop.org;
  };
}
