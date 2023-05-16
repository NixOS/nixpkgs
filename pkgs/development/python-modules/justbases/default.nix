{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchFromGitHub
, unittestCheckHook
=======
, fetchPypi
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, hypothesis
}:

buildPythonPackage rec {
  pname = "justbases";
<<<<<<< HEAD
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "mulkieran";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-XraUh3beI2JqKPRHYN5W3Tn3gg0GJCwhnhHIOFdzh6U=";
  };

  nativeCheckInputs = [
    unittestCheckHook
    hypothesis
  ];

  meta = with lib; {
    description = "conversion of ints and rationals to any base";
    homepage = "https://github.com/mulkieran/justbases";
    changelog = "https://github.com/mulkieran/justbases/blob/v${version}/CHANGES.txt";
=======
  version = "0.15";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vQEfC8Z7xMM/fhBG6jSuhLEP/Iece5Rje1yqbpjVuPg=";
  };

  nativeCheckInputs = [ hypothesis ];

  meta = with lib; {
    description = "conversion of ints and rationals to any base";
    homepage = "https://pythonhosted.org/justbases";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ nickcao ];
  };
}
