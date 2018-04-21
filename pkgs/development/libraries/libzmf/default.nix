{stdenv, fetchurl, boost, icu, libpng, librevenge, zlib, doxygen, pkgconfig, cppunit}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "libzmf";
  version = "0.0.2";
  
  src = fetchurl {
    url = "http://dev-www.libreoffice.org/src/libzmf/${name}.tar.xz";
    sha256 = "08mg5kmkjrmqrd8j5rkzw9vdqlvibhb1ynp6bmfxnzq5rcq1l197";
  };

  buildInputs = [boost icu libpng librevenge zlib cppunit];
  nativeBuildInputs = [doxygen pkgconfig];
  configureFlags = " --disable-werror ";

  meta = {
    inherit version;
    description = ''A library that parses the file format of Zoner Callisto/Draw documents'';
    license = stdenv.lib.licenses.mpl20;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = https://wiki.documentfoundation.org/DLP/Libraries/libzmf;
    downloadPage = "http://dev-www.libreoffice.org/src/libzmf/";
    updateWalker = true;
  };
}
