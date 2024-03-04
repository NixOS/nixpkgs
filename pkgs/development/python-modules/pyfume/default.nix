{ lib
, buildPythonPackage
, fetchPypi
, fst-pso
, numpy
, pandas
, pythonOlder
, scipy
, setuptools
, simpful
}:

buildPythonPackage rec {
  pname = "pyfume";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "pyFUME";
    inherit version;
    hash = "sha256-dZKp+BGwOSRlPcaDmY8LRJZEdJA3WaIGcBBOek5ZMf4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
    changelog = "https://github.com/CaroFuchs/pyFUME/releases/tag/${version}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
