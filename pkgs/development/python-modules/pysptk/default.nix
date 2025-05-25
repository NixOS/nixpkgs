{
  lib,
  buildPythonPackage,
  cython,
  decorator,
  fetchPypi,
  numpy,
  pythonOlder,
  scipy,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "pysptk";
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eLHJM4v3laQc3D/wP81GmcQBwyP1RjC7caGXEAeNCz8=";
  };

  PYSPTK_BUILD_VERSION = 0;

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [
    decorator
    numpy
    scipy
    setuptools
    six
  ];

  # Tests are not part of the PyPI releases
  doCheck = false;

  pythonImportsCheck = [ "pysptk" ];

  meta = with lib; {
    description = "Wrapper for Speech Signal Processing Toolkit (SPTK)";
    homepage = "https://pysptk.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
