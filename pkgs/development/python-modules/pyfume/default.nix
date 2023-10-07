{ lib
, buildPythonPackage
, fetchPypi
, fst-pso
, numpy
, pandas
, pythonOlder
, scipy
, simpful
}:

buildPythonPackage rec {
  pname = "pyfume";
  version = "0.2.25";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "pyFUME";
    inherit version;
    hash = "sha256-uD1IHFyNd9yv3eyHPZ4pg6X2+rLTY5sYsQysuIXbvfA=";
  };

  propagatedBuildInputs = [
    fst-pso
    numpy
    pandas
    scipy
    simpful
  ];

  # Module has not test
  doCheck = false;

  pythonImportsCheck = [
    "pyfume"
  ];

  meta = with lib; {
    description = "A Python package for fuzzy model estimation";
    homepage = "https://github.com/CaroFuchs/pyFUME";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
