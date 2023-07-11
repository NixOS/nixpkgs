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
  version = "2.0.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "FuzzyTM";
    inherit version;
    hash = "sha256-IELkjd3/yc2lBYsLP6mms9LEcXOfVtNNooEKCMf9BtU=";
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
