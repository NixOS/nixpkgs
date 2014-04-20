{stdenv, fetchurl, automake, autoconf, pkgconfig, libtool, python, pythonPackages, glib, jansson}:

stdenv.mkDerivation rec
{
  version = "1.2.1";
  seafileVersion = "2.1.1";
  name = "libsearpc-${version}";

  src = fetchurl
  {
    url = "https://github.com/haiwen/libsearpc/archive/v${seafileVersion}.tar.gz";
    sha256 = "c0e7cc812c642ebb1339c3701570e78ff5b8c8aa2a521e5a505e28d9666e89ec";
  };

  patches = [ ./libsearpc.pc.patch ];

  buildInputs = [ automake autoconf pkgconfig libtool python pythonPackages.simplejson ];
  propagatedBuildInputs = [ glib jansson ];

  preConfigure = "./autogen.sh";

  buildPhase = "make -j1";

  meta =
  {
    homepage = "https://github.com/haiwen/libsearpc";
    description = "A simple and easy-to-use C language RPC framework (including both server side & client side) based on GObject System.";
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.calrama ];
  };
}