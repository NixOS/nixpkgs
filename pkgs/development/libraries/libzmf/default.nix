{
  lib,
  stdenv,
  fetchurl,
  boost,
  icu,
  libpng,
  librevenge,
  zlib,
  doxygen,
  pkg-config,
  cppunit,
}:

stdenv.mkDerivation rec {
  pname = "libzmf";
  version = "0.0.2";

  src = fetchurl {
    url = "http://dev-www.libreoffice.org/src/libzmf/${pname}-${version}.tar.xz";
    sha256 = "08mg5kmkjrmqrd8j5rkzw9vdqlvibhb1ynp6bmfxnzq5rcq1l197";
  };

  buildInputs = [
    boost
    icu
    libpng
    librevenge
    zlib
    cppunit
  ];
  nativeBuildInputs = [
    doxygen
    pkg-config
  ];
  configureFlags = [ "--disable-werror" ];

  meta = {
    description = "A library that parses the file format of Zoner Callisto/Draw documents";
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
    homepage = "https://wiki.documentfoundation.org/DLP/Libraries/libzmf";
    downloadPage = "http://dev-www.libreoffice.org/src/libzmf/";
  };
}
