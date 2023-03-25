{ lib, stdenv, fetchurl, readline, gmp, zlib }:

stdenv.mkDerivation rec {
  version = "6.3.3";
  pname = "yap";

  src = fetchurl {
    url = "https://www.dcc.fc.up.pt/~vsc/Yap/${pname}-${version}.tar.gz";
    sha256 = "0y7sjwimadqsvgx9daz28c9mxcx9n1znxklih9xg16k6n54v9qxf";
  };

  buildInputs = [ readline gmp zlib ];

  configureFlags = [ "--enable-tabling=yes" ];

  # -fcommon: workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: libYap.a(pl-dtoa.o):/build/yap-6.3.3/H/pl-yap.h:230: multiple definition of `ATOM_';
  #     libYap.a(pl-buffer.o):/build/yap-6.3.3/H/pl-yap.h:230: first defined here
  env.NIX_CFLAGS_COMPILE = "-fpermissive -fcommon";

  meta = {
    # the linux 32 bit build fails.
    broken = (stdenv.isLinux && stdenv.isAarch64) || !stdenv.is64bit;
    homepage = "http://www.dcc.fc.up.pt/~vsc/Yap/";
    description = "A ISO-compatible high-performance Prolog compiler";
    license = lib.licenses.artistic2;

    platforms = lib.platforms.linux;
  };
}
