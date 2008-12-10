args: with args;

stdenv.mkDerivation rec {
  name = "gstreamer-" + version;

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer/${name}.tar.bz2";
    sha256 = "172nqf6l6mq4r1923bph53xd6h3svha3kkrvy5cald77jgf64a24";
  };

  buildInputs = [perl bison flex pkgconfig python];
  propagatedBuildInputs = [glib libxml2];

  configureFlags = "--enable-shared --disable-static --enable-failing-tests
    --localstatedir=/var";

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = http://gstreamer.freedesktop.org;
  };
}
