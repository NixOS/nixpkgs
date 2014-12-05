{ stdenv, fetchurl, pkgconfig, e19, libcap, gdbm }:
stdenv.mkDerivation rec {
  name = "elementary-${version}";
  version = "1.11.3";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/elementary/${name}.tar.gz";
    sha256 = "1yr96imam9sckgagnp7wdvwmvr1xwakw29dih3gxp7nz7xsa0j8k";
  };
  buildInputs = [ pkgconfig e19.efl gdbm ] ++ stdenv.lib.optionals stdenv.isLinux [ libcap ];
  preConfigure = ''
    export NIX_CFLAGS_COMPILE="-I${e19.efl}/include/ethumb-1 $NIX_CFLAGS_COMPILE"
  '';
  meta = {
    description = "Widget set/toolkit";
    homepage = http://enlightenment.org/;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl2;
  };
}
