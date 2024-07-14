{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  cython,
}:

buildPythonPackage rec {
  pname = "libmr";
  version = "0.1.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-Q8zYZpO3Jfo6vmSMjNzvF7pfpGtVKBaIKeX5uWjf63A=";
  };

  propagatedBuildInputs = [
    numpy
    cython
  ];

  # No tests in the pypi tarball
  doCheck = false;

  meta = with lib; {
    description = "libMR provides core MetaRecognition and Weibull fitting functionality";
    homepage = "https://github.com/Vastlab/libMR";
    license = licenses.bsd3;
    maintainers = with maintainers; [ psyanticy ];
  };
}
