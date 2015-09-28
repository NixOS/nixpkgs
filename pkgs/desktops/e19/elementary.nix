{ stdenv, fetchurl, pkgconfig, e19, libcap, automake, autoconf, libdrm, gdbm }:
stdenv.mkDerivation rec {
  name = "elementary-${version}";
  version = "1.15.0";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/elementary/${name}.tar.gz";
    sha256 = "085s2xw3dhv8xiy7ikaaim5gil423g08wclhk0psi76g0vavgd32";
  };
  buildInputs = [ pkgconfig e19.efl libdrm gdbm automake autoconf ] ++ stdenv.lib.optionals stdenv.isLinux [ libcap ];
  NIX_CFLAGS_COMPILE = [ "-I${libdrm}/include/libdrm" ];
  patches = [ ./elementary.patch ];
  enableParallelBuilding = true;
  meta = {
    description = "Widget set/toolkit";
    homepage = http://enlightenment.org/;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ftrvxmtrx ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl2;
  };
}
