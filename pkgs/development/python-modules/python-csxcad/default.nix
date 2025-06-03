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

  meta = with lib; {
    description = "Python interface to CSXCAD";
    homepage = "http://openems.de/index.php/Main_Page.html";
    license = licenses.gpl3;
    maintainers = with maintainers; [ matthuszagh ];
    platforms = platforms.linux;
  };
}
