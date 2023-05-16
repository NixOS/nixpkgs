{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonRelaxDepsHook
, rapidfuzz
, click
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "jiwer";
<<<<<<< HEAD
  version = "3.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jitsi";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-z+M0/mftitLV2OaaQvTdRehtt16FFeBjqR//S5ad1XE=";
=======
  version = "3.0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jitsi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-bH5TE6mcSG+WqvjW8Sd/o5bCBJmv9zurFEG2cVY/vYQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    rapidfuzz
    click
  ];

  pythonRelaxDeps = [
    "rapidfuzz"
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "jiwer"
  ];
=======
  pythonImportsCheck = [ "jiwer" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A simple and fast python package to evaluate an automatic speech recognition system";
    homepage = "https://github.com/jitsi/jiwer";
<<<<<<< HEAD
    changelog = "https://github.com/jitsi/jiwer/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
