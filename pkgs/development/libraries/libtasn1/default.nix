{ stdenv, fetchurl, perl, texinfo }:

stdenv.mkDerivation rec {
  name = "libtasn1-4.9";

  src = fetchurl {
    url = "mirror://gnu/libtasn1/${name}.tar.gz";
    sha256 = "0869cp6jx7cajgv6cnddsh3vc7bimmdkdjn80y1jpb4iss7plvsg";
  };

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  # Warning causes build to fail on darwin since 4.9,
  # check if this can be removed in the next release.
  CFLAGS = "-Wno-sign-compare";

  buildInputs = [ perl texinfo ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://www.gnu.org/software/libtasn1/;
    description = "An ASN.1 library";
    longDescription = ''
      Libtasn1 is the ASN.1 library used by GnuTLS, GNU Shishi and some
      other packages.  The goal of this implementation is to be highly
      portable, and only require an ANSI C89 platform.
    '';
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
