{ stdenv, fetchurl, perl, texinfo }:

stdenv.mkDerivation rec {
  name = "libtasn1-3.6";

  src = fetchurl {
    url = "mirror://gnu/libtasn1/${name}.tar.gz";
    sha256 = "0c547qa1vfk1x2jzgjhf65izf4sfi86c6g46q7779g4aldk4gqqr";
  };

  buildInputs = [ perl texinfo ];

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/libtasn1/;
    description = "GNU Libtasn1, an ASN.1 library";

    longDescription =
      '' Libtasn1 is the ASN.1 library used by GnuTLS, GNU Shishi and some
         other packages.  The goal of this implementation is to be highly
         portable, and only require an ANSI C89 platform.
      '';

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
