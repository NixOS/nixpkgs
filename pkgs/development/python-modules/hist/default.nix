{ lib
, fetchPypi
, buildPythonPackage
, boost-histogram
, histoprint
, hatchling
, hatch-vcs
, numpy
, pytestCheckHook
, pytest-mpl
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "hist";
<<<<<<< HEAD
  version = "2.7.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/74xTCvQPDQrnxaNznFa2PNigesjFyoAlwiCqTRP6Yg=";
=======
  version = "2.6.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dede097733d50b273af9f67386e6dcccaab77e900ae702e1a9408a856e217ce9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
    boost-histogram
    histoprint
    numpy
  ];

  checkInputs = [
    pytestCheckHook
    pytest-mpl
  ];

  meta = with lib; {
    description = "Histogramming for analysis powered by boost-histogram";
<<<<<<< HEAD
    homepage = "https://hist.readthedocs.io/";
    changelog = "https://github.com/scikit-hep/hist/releases/tag/v${version}";
=======
    homepage = "https://hist.readthedocs.io/en/latest/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
