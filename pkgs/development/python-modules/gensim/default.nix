{ lib
, buildPythonPackage
, cython
, fetchPypi
, mock
, numpy
, scipy
, smart-open
, testfixtures
, pyemd
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "gensim";
  version = "4.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZL1+ximQIVh4gi6LJWnRg1BU9WzfU2AN3+mSfjHztI0=";
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    smart-open
    numpy
    scipy
  ];

  checkInputs = [
    mock
    pyemd
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "gensim"
  ];

  # Test setup takes several minutes
  doCheck = false;

  pytestFlagsArray = [
    "gensim/test"
  ];

  meta = with lib; {
    description = "Topic-modelling library";
    homepage = "https://radimrehurek.com/gensim/";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ jyp ];
  };
}
