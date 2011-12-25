{ stdenv, fetchgit, cmake, libxml2, libxslt, python27Packages, qt4 }:

stdenv.mkDerivation {
  name = "pyside-apiextractor-0.10.7-6-gdcb1195";

  src = fetchgit {
    url = "git://github.com/PySide/Apiextractor.git";
    rev = "dcb11958cabe518630f9f2d2bebd9f8711c2b15b";
    sha256 = "d7b6cb16d11b6134de17a15635d0b5ad7460d31d7870cafe23a690141b9a2274";
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake libxml2 libxslt python27Packages.sphinx qt4 ];

  meta = {
    description = "Eases the development of bindings of Qt-based libraries for high level languages by automating most of the process";
    license = stdenv.lib.licenses.gpl2;
    homepage = "http://www.pyside.org/docs/apiextractor/";
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.all;
  };
}
