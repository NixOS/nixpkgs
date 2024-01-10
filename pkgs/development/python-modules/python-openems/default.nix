{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, openems
, csxcad
, boost
, python-csxcad
, numpy
, h5py
}:

buildPythonPackage rec {
  pname = "python-openems";
  version = openems.version;
  format = "setuptools";

  src = openems.src;

  sourceRoot = "${src.name}/python";

  nativeBuildInputs = [
    cython
    boost
  ];

  propagatedBuildInputs = [
    openems
    csxcad
    python-csxcad
    numpy
    h5py
  ];

  setupPyBuildFlags = [ "-I${openems}/include" "-L${openems}/lib" "-R${openems}/lib" ];
  pythonImportsCheck = [ "openEMS" ];

  meta = with lib; {
    description = "Python interface to OpenEMS";
    homepage = "http://openems.de/index.php/Main_Page.html";
    license = licenses.gpl3;
    maintainers = with maintainers; [ matthuszagh ];
    platforms = platforms.linux;
  };
}
