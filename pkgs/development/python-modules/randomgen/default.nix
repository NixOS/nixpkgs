{ lib
, buildPythonPackage
, fetchPypi
, cython
, numpy
, packaging
, setuptools
, setuptools-scm
, wheel
}:

buildPythonPackage rec {
  pname = "randomgen";
  version = "1.23.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gmMZ6Pz0YppGCvDIZJ32XFXYi8OEzN5B90hekqKuwXw=";
  };

  nativeBuildInputs = [
    cython
    numpy
    packaging
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    cython
    numpy
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "randomgen" ];

  meta = with lib; {
    description = "Random generator supporting multiple PRNGs";
    homepage = "https://pypi.org/project/randomgen";
    license = licenses.ncsa;
    maintainers = with maintainers; [ ];
  };
}
