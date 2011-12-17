{ stdenv, fetchgit, cmake, pyside, python27, qt4, pysideShiboken }:

stdenv.mkDerivation {
  name = "pyside-tools-0.2.13";

  src = fetchgit {
    url = "git://github.com/PySide/Tools.git";
    rev = "23e0712360442e50f34be0d6e4651b8c4c806d47";
    sha256 = "68f059e4936fb8dfae6aa3a463db8c28adcb7bd050b29e8b6fef82431f72da07";
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake pyside python27 qt4 pysideShiboken ];

  meta = {
    description = "Tools for pyside, the LGPL-licensed Python bindings for the Qt cross-platform application and UI framework.";
    license = stdenv.lib.licenses.gpl2;
    homepage = "http://www.pyside.org";
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.all;
  };
}
