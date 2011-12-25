{ stdenv, fetchgit, cmake, pysideApiextractor, python27Packages, qt4 }:

stdenv.mkDerivation {
  name = "pyside-generatorrunner-0.6.13-9-g567ca6e";

  src = fetchgit {
    url = "git://github.com/PySide/Generatorrunner.git";
    rev = "567ca6effaecdf97b33d1d13eada23bafe0f7535";
    sha256 = "182aba79af9fc865337f4befc96faf3eaca1ab9bcb902a57e0a68af49f071c74";
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake pysideApiextractor python27Packages.sphinx qt4 ];

  meta = {
    description = "Eases the development of binding generators for C++ and Qt-based libraries by providing a framework to help automating most of the process";
    license = stdenv.lib.licenses.gpl2;
    homepage = "http://www.pyside.org/docs/generatorrunner/";
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.all;
  };
}
