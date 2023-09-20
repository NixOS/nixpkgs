{ lib, stdenv, fetchurl, perl, zlib }:
stdenv.mkDerivation rec {
  pname = "libeb";
  version = "4.4.3";

  src = fetchurl {
    url = "ftp://ftp.sra.co.jp/pub/misc/eb/eb-${version}.tar.bz2";
    sha256 = "0psbdzirazfnn02hp3gsx7xxss9f1brv4ywp6a15ihvggjki1rxb";
  };

  nativeBuildInputs = [ perl ];
  buildInputs = [ zlib ];

  meta = with lib; {
    description = "C library for accessing Japanese CD-ROM books";
    longDescription = ''
      The EB library is a library for accessing CD-ROM books, which are a
      common way to distribute electronic dictionaries in Japan.  It supports
      the EB, EBG, EBXA, EBXA-C, S-EBXA and EPWING formats.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ gebner ];
    platforms = with platforms; unix;
  };
}
