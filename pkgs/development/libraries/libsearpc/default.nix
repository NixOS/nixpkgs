{ stdenv, fetchgit, automake, autoconf, pkgconfig, libtool, python
, pythonPackages, glib, jansson }:
stdenv.mkDerivation rec
{
  version = "v3.0-20140814";
  name = "libsearpc-${version}";

  src = fetchgit
  {
    url = "git://github.com/haiwen/libsearpc";
    rev = "8998e7b2c5587f0b94c48db24e2952d08def5add";
    sha256 = "1ha2bp0i2iy2bjxcdnmd3vw7jq85y29fdzmz5vqdqpsa584mv4kr";
  };

  patches = [ ./libsearpc.pc.patch ];

  buildInputs = [ automake autoconf pkgconfig libtool python pythonPackages.simplejson ];
  propagatedBuildInputs = [ glib jansson ];

  preConfigure = "./autogen.sh";

  makeFlags = [ "-j1" ];

  meta =
  {
    homepage = "https://github.com/haiwen/libsearpc";
    description = "A simple and easy-to-use C language RPC framework (including both server side & client side) based on GObject System";
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.calrama stdenv.lib.maintainers.matejc ];
  };
}
