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

  nativeCheckInputs = [
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
    # python310 errors as: No matching distribution found for FuzzyTM>=0.4.0
    # python311 errors as: longintrepr.h: No such file or directory
    broken = true; # At 2023-02-05
  };
}
