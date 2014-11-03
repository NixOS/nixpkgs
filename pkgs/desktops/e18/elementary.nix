{ stdenv, fetchurl, pkgconfig, e18 }:
stdenv.mkDerivation rec {
  name = "elementary-${version}";
  version = "1.10.2";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/elementary/${name}.tar.gz";
    sha256 = "0y3knvmabl9adc8pd54p7qxpf7gvciixc1rk40hqppwhdgbgpz28";
  };
  buildInputs = [ pkgconfig e18.efl ];
  preConfigure = ''
    export NIX_CFLAGS_COMPILE="-I${e18.efl}/include/ethumb-1 $NIX_CFLAGS_COMPILE"
  '';
  meta = {
    description = "Widget set/toolkit";
    homepage = http://enlightenment.org/;
    maintainers = [ stdenv.lib.maintainers.matejc ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl2;
  };
}
