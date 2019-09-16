{ stdenv, fetchurl, perl, texinfo }:

stdenv.mkDerivation rec {
  name = "libtasn1-4.14";

  src = fetchurl {
    url = "mirror://gnu/libtasn1/${name}.tar.gz";
    sha256 = "025sqnlzji78ss2fi78dajc0v0h5fi02wp39hws41sn8qnjlnq4y";
  };

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  nativeBuildInputs = [ texinfo perl ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://www.gnu.org/software/libtasn1/;
    description = "An ASN.1 library";
    longDescription = ''
      Libtasn1 is the ASN.1 library used by GnuTLS, GNU Shishi and some
      other packages.  The goal of this implementation is to be highly
      portable, and only require an ANSI C89 platform.
    '';
    license = licenses.lgpl2Plus;
    platforms = platforms.all;
  };
}
