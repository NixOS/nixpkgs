{stdenv, fetchurl, automake, autoconf, pkgconfig, libtool, python2Packages, glib, jansson}:

stdenv.mkDerivation rec
{
  version = "3.0.7";
  seafileVersion = "5.0.7";
  name = "libsearpc-${version}";

  src = fetchurl
  {
    url = "https://github.com/haiwen/libsearpc/archive/v${version}.tar.gz";
    sha256 = "0fdrgksdwd4qxp7qvh75y39dy52h2f5wfjbqr00h3rwkbx4npvpg";
  };

  patches = [ ./libsearpc.pc.patch ];

  buildInputs = [ automake autoconf pkgconfig libtool python2Packages.python python2Packages.simplejson ];
  propagatedBuildInputs = [ glib jansson ];

  preConfigure = "./autogen.sh";

  buildPhase = "make -j1";

  meta =
  {
    homepage = https://github.com/haiwen/libsearpc;
    description = "A simple and easy-to-use C language RPC framework (including both server side & client side) based on GObject System";
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.calrama ];
  };
}
