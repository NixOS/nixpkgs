{ lib
, buildPythonPackage
, fetchPypi
, gensim
, numpy
, pandas
, pyfume
, scipy
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fuzzytm";
  version = "2.0.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "FuzzyTM";
    inherit version;
    hash = "sha256-z0ESYtB7BqssxIHlrd0F+/qapOM1nrDi3Zih5SvgDGY=";
  };

  propagatedBuildInputs = [
    gensim
    numpy
    pandas
    pyfume
    scipy
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "FuzzyTM"
  ];

  meta = with lib; {
    description = "Library for Fuzzy Topic Models";
    homepage = "https://github.com/ERijck/FuzzyTM";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
