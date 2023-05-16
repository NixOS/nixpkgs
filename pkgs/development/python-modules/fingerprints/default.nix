{ lib
<<<<<<< HEAD
, fetchFromGitHub
, buildPythonPackage
, normality
, pytestCheckHook
=======
, fetchPypi
, buildPythonPackage
, normality
, mypy
, coverage
, nose
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:
buildPythonPackage rec {
  pname = "fingerprints";
  version = "1.1.0";

<<<<<<< HEAD
  src = fetchFromGitHub {
    owner = "alephdata";
    repo = "fingerprints";
    rev = version;
    hash = "sha256-rptBM08dvivfglPvl3PZd9V/7u2SHbJ/BxfVHNGMt3A=";
=======
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GZmurg3rpD081QZW/LUKWblhsQQSS6lg9O7y/kGy4To=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    normality
  ];

  nativeCheckInputs = [
<<<<<<< HEAD
    pytestCheckHook
  ];

=======
    mypy
    coverage
    nose
  ];

  checkPhase = ''
    nosetests
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "fingerprints"
  ];

  meta = with lib; {
    description = "A library to generate entity fingerprints";
    homepage = "https://github.com/alephdata/fingerprints";
    license = licenses.mit;
    maintainers = [ ];
  };
}
