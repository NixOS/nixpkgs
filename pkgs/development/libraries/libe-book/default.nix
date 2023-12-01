{ lib
, stdenv
, fetchurl
, gperf
, pkg-config
, librevenge
, libxml2
, boost
, icu
, cppunit
, zlib
, liblangtag
}:

stdenv.mkDerivation rec {
  pname = "libe-book";
  version = "0.1.3";

  src = fetchurl {
    url = "mirror://sourceforge/libebook/libe-book-${version}/libe-book-${version}.tar.xz";
    hash = "sha256-fo2P808ngxrKO8b5zFMsL5DSBXx3iWO4hP89HjTf4fk=";
  };

  # restore compatibility with icu68+
  postPatch = ''
    substituteInPlace src/lib/EBOOKCharsetConverter.cpp --replace \
      "TRUE, TRUE, &status)" \
      "true, true, &status)"
  '';
  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gperf
    librevenge
    libxml2
    boost
    icu
    cppunit
    zlib
    liblangtag
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=unused-function";

  meta = with lib; {
    description = "Library for import of reflowable e-book formats";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
  };
}
