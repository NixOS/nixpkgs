{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libtasn1-2.14";

  src = fetchurl {
    url = "mirror://gnu/libtasn1/${name}.tar.gz";
    sha256 = "0m1x2p04xpacl18dzv1hmsm2fk97gi167ra5h4kmjy16436kcadw";
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

    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
