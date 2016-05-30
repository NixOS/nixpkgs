{ stdenv, fetchurl, pkgconfig, efl, libcap, automake, autoconf, libdrm, gdbm }:
stdenv.mkDerivation rec {
  name = "elementary-${version}";
  version = "1.17.1";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/elementary/${name}.tar.xz";
    sha256 = "149xjq4z71l44w1kd8zks9b2g0wjc9656w46hzd27b58afj1dqc5";
  };
  nativeBuildInputs = [ pkgconfig automake autoconf ];
  buildInputs = [ efl libdrm gdbm ] ++ stdenv.lib.optionals stdenv.isLinux [ libcap ];
  NIX_CFLAGS_COMPILE = [ "-I${libdrm.dev}/include/libdrm" ];
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
