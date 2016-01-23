{ stdenv, fetchurl, pkgconfig, e19, libcap, automake114x, autoconf, libdrm, gdbm }:
stdenv.mkDerivation rec {
  name = "elementary-${version}";
  version = "1.16.1";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/elementary/${name}.tar.xz";
    sha256 = "0q58imh7s35q6cq5hsa6gqj84rkckh8s61iass8zyvcw19j66f3y";
  };
  buildInputs = [ pkgconfig e19.efl libdrm gdbm automake114x autoconf ] ++ stdenv.lib.optionals stdenv.isLinux [ libcap ];
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
