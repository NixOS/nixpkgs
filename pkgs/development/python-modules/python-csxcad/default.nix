{
  lib,
  buildPythonPackage,
  cython,
  openems,
  csxcad,
  numpy,
  matplotlib,
}:

buildPythonPackage rec {
  pname = "python-csxcad";
  version = csxcad.version;
  format = "setuptools";

  src = csxcad.src;

  sourceRoot = "${src.name}/python";

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [
    openems
    csxcad
    numpy
    matplotlib
  ];

  setupPyBuildFlags = [
    "-I${openems}/include"
    "-L${openems}/lib"
    "-R${openems}/lib"
  ];

  meta = {
    description = "Python interface to CSXCAD";
    homepage = "http://openems.de/index.php/Main_Page.html";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ matthuszagh ];
    platforms = lib.platforms.linux;
  };
}
