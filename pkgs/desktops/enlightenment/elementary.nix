{ stdenv, fetchurl, pkgconfig, efl, libcap, automake, autoconf, libdrm, gdbm }:
stdenv.mkDerivation rec {
  name = "elementary-${version}";
  version = "1.17.0";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/elementary/${name}.tar.xz";
    sha256 = "0avb0d6nk4d88l81c2j6py13vdfnvg080ycw2y3qvawyjf1mhska";
  };
  buildInputs = [ pkgconfig efl libdrm gdbm automake autoconf ] ++ stdenv.lib.optionals stdenv.isLinux [ libcap ];
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
