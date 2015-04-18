{ stdenv, fetchurl, pkgconfig, e19, libcap, gdbm }:
stdenv.mkDerivation rec {
  name = "elementary-${version}";
  version = "1.13.2";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/elementary/${name}.tar.gz";
    sha256 = "0f8hz60aj4ar8lqnc63nlxkpf3b51scjalgy1iphgjc27hzxcb9i";
  };
  buildInputs = [ pkgconfig e19.efl gdbm ] ++ stdenv.lib.optionals stdenv.isLinux [ libcap ];
  preConfigure = ''
    export NIX_CFLAGS_COMPILE="-I${e19.efl}/include/ethumb-1 -I${e19.efl}/include/efl-1 $NIX_CFLAGS_COMPILE"
  '';
  enableParallelBuilding = true;
  meta = {
    description = "Widget set/toolkit";
    homepage = http://enlightenment.org/;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl2;
  };
}
