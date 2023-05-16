{ lib
<<<<<<< HEAD
, fetchPypi
=======
, fetchurl
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "0.3.0";
=======
  version = "0.2.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

<<<<<<< HEAD
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0TqR6jaV34gUZePTYTLX7vToTUg/S6U4pLRuJLXqEA8=";
=======
  src = fetchurl {
    url = "mirror://pypi/h/hmmlearn/${pname}-${version}.tar.gz";
    hash = "sha256-aWkx49zmgBzJt4xin1QwYd1+tnpxFVsD0bOeoXKipfk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
