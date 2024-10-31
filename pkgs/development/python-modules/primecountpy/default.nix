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
    sha256 = "78fe7cc32115f0669a45d7c90faaf39f7ce3939e39e2e7e5f14c17fe4bff0676";
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
