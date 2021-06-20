{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
, cython
}:

buildPythonPackage rec {
  pname = "pyclipper";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "ca3751e93559f0438969c46f17459d07f983281dac170c3479de56492e152855";
  };

  nativeBuildInputs = [
    setuptools-scm
    cython
  ];

  # Requires pytest_runner to perform tests, which requires deprecated
  # features of setuptools. Seems better to not run tests. This should
  # be fixed upstream.
  doCheck = false;
  pythonImportsCheck = [ "pyclipper" ];

  meta = with lib; {
    description = "Cython wrapper for clipper library";
    homepage    = "https://github.com/fonttools/pyclipper";
    license     = licenses.mit;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
