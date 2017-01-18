{ stdenv, fetchurl, perl, texinfo }:

stdenv.mkDerivation rec {
  name = "libtasn1-4.10";

  src = fetchurl {
    url = "mirror://gnu/libtasn1/${name}.tar.gz";
    sha256 = "681a4d9a0d259f2125713f2e5766c5809f151b3a1392fd91390f780b4b8f5a02";
  };

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  buildInputs = [ perl texinfo ];

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/libtasn1/;
    description = "An ASN.1 library";

    longDescription =
      '' Libtasn1 is the ASN.1 library used by GnuTLS, GNU Shishi and some
         other packages.  The goal of this implementation is to be highly
         portable, and only require an ANSI C89 platform.
      '';

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = with stdenv.lib.maintainers; [ wkennington ];
    platforms = stdenv.lib.platforms.all;
  };
}
