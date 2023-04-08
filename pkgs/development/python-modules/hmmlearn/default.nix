{ lib
, fetchurl
, buildPythonPackage
, numpy
, scikit-learn
, pybind11
, setuptools-scm
, cython
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hmmlearn";
  version = "0.2.8";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchurl {
    url = "mirror://pypi/h/hmmlearn/${pname}-${version}.tar.gz";
    hash = "sha256-aWkx49zmgBzJt4xin1QwYd1+tnpxFVsD0bOeoXKipfk=";
  };

  buildInputs = [
    setuptools-scm
    cython
    pybind11
  ];

  propagatedBuildInputs = [
    numpy
    scikit-learn
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "hmmlearn"
  ];

  pytestFlagsArray = [
    "--pyargs"
    "hmmlearn"
  ];

  meta = with lib; {
    description = "Hidden Markov Models in Python with scikit-learn like API";
    homepage = "https://github.com/hmmlearn/hmmlearn";
    license = licenses.bsd3;
    maintainers = with maintainers; [ abbradar ];
  };
}
