{ lib
, stdenv
, buildPythonPackage
, cython
, decorator
, fetchPypi
, numpy
, pytestCheckHook
, pythonOlder
, scipy
, six
}:

buildPythonPackage rec {
  pname = "pysptk";
  version = "0.1.21";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AZUDI9AL57tXz7VzPGF9uEeKW4/6JsaBUiFkigl640Q=";
  };

  PYSPTK_BUILD_VERSION = 0;

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    decorator
    numpy
    scipy
    six
  ];

  # Tests are not part of the PyPI releases
  doCheck = false;

  pythonImportsCheck = [
    "pysptk"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Wrapper for Speech Signal Processing Toolkit (SPTK)";
    homepage = "https://pysptk.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
