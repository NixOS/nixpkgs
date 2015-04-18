{stdenv, fetchurl, automake, autoconf, pkgconfig, libtool, python, pythonPackages, glib, jansson}:

stdenv.mkDerivation rec
{
  version = "1.2.2";
  seafileVersion = "3.0-latest";
  name = "libsearpc-${version}";

  src = fetchurl
  {
    url = "https://github.com/haiwen/libsearpc/archive/v${seafileVersion}.tar.gz";
    sha256 = "1kdq6chn3qhvr616sw91gf9kjfgbv9snl2srqisw0zddw1qkfcan";
  };

  patches = [ ./libsearpc.pc.patch ];

  buildInputs = [ automake autoconf pkgconfig libtool python pythonPackages.simplejson ];
  propagatedBuildInputs = [ glib jansson ];

  preConfigure = "./autogen.sh";

  buildPhase = "make -j1";

  meta =
  {
    homepage = "https://github.com/haiwen/libsearpc";
    description = "A simple and easy-to-use C language RPC framework (including both server side & client side) based on GObject System";
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.calrama ];
  };
}
