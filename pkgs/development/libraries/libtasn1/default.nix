{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libtasn1-2.10";

  src = fetchurl {
    url = "mirror://gnu/libtasn1/${name}.tar.gz";
    sha256 = "1l0622ysv68k1xazg3000m47h8dd7pbnxhik6v0kf17029ic1r0p";
  };

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/libtasn1/;
    description = "GNU Libtasn1, an ASN.1 library";

    longDescription =
      '' Libtasn1 is the ASN.1 library used by GnuTLS, GNU Shishi and some
         other packages.  The goal of this implementation is to be highly
         portable, and only require an ANSI C89 platform.
      '';

    license = "LGPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}
