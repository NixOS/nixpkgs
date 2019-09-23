{ lib
, isPy3k
, buildPythonPackage
, fetchPypi
, pytestrunner
, setuptools_scm
, isort
, mpmath
, strategies
}:

buildPythonPackage rec {
  pname = "diofant";
  version = "0.10.0";

  src = fetchPypi {
    inherit version;
    pname = "Diofant";
    sha256 = "0qjg0mmz2cqxryr610mppx3virf1gslzrsk24304502588z53v8w";
  };

  nativeBuildInputs = [
    isort
    pytestrunner
    setuptools_scm
  ];

  propagatedBuildInputs = [
    mpmath
    strategies
  ];

  # tests take ~1h
  doCheck = false;

  disabled = !isPy3k;

  meta = with lib; {
    description = "A Python CAS library";
    homepage = "https://diofant.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ suhr ];
  };
}
