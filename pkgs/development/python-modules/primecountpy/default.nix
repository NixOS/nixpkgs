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
  version = "0.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-yFYYF8C+hu7/xBuXtu9hfXlfcs895Z2SNNHIPX5CQDA=";
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
    teams = [ teams.sage ];
    license = licenses.gpl3Only;
  };
}
