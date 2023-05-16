{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchFromGitHub
, justbases
, unittestCheckHook
=======
, fetchPypi
, justbases
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, hypothesis
}:

buildPythonPackage rec {
  pname = "justbytes";
<<<<<<< HEAD
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "mulkieran";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+jwIK1ZU+j58VoOfZAm7GdFy7KHU28khwzxhYhcws74=";
  };

  propagatedBuildInputs = [ justbases ];
  nativeCheckInputs = [ unittestCheckHook hypothesis ];

  meta = with lib; {
    description = "computing with and displaying bytes";
    homepage = "https://github.com/mulkieran/justbytes";
=======
  version = "0.15";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qrMO9X0v5yYjeWa72mogegR+ii8tCi+o7qZ+Aff2wZQ=";
  };

  propagatedBuildInputs = [ justbases ];
  nativeCheckInputs = [ hypothesis ];

  meta = with lib; {
    description = "computing with and displaying bytes";
    homepage = "https://pythonhosted.org/justbytes";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ nickcao ];
  };
}
