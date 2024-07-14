{
  lib,
  fetchPypi,
  buildPythonPackage,
  primecount,
  cython,
  cysignals,

  # Reverse dependency
  sage,
}:

buildPythonPackage rec {
  pname = "primecountpy";
  version = "0.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eP58wyEV8GaaRdfJD6rzn3zjk5454ufl8UwX/kv/BnY=";
  };

  buildInputs = [ primecount ];

  propagatedBuildInputs = [
    cython
    cysignals
  ];

  # depends on pytest-cython for "pytest --doctest-cython"
  doCheck = false;

  pythonImportsCheck = [ "primecountpy" ];

  passthru.tests = {
    inherit sage;
  };

  meta = with lib; {
    description = "Cython interface for C++ primecount library";
    homepage = "https://github.com/dimpase/primecountpy/";
    maintainers = teams.sage.members;
    license = licenses.gpl3Only;
  };
}
