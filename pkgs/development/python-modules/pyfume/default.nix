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
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "pyFUME";
    inherit version;
    hash = "sha256-dZKp+BGwOSRlPcaDmY8LRJZEdJA3WaIGcBBOek5ZMf4=";
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
