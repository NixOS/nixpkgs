{ stdenv, fetchurl, perl, texinfo }:

stdenv.mkDerivation rec {
  name = "libtasn1-4.7";

  src = fetchurl {
    url = "mirror://gnu/libtasn1/${name}.tar.gz";
    sha256 = "1j8iixynchziw1y39lnibyl5h81m4p78w3i4f28q2vgwjgf801x4";
  };

  outputs = [ "dev" "out" "docdev" ];
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
