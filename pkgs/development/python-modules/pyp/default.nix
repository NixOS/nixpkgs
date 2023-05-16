{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, coreutils
, pythonOlder
, astunparse
<<<<<<< HEAD
, flit-core
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, jq
, bc
}:

buildPythonPackage rec {
  pname = "pyp";
  version = "1.1.0";
<<<<<<< HEAD
  format = "pyproject";
=======
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "hauntsaninja";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-A1Ip41kxH17BakHEWEuymfa24eBEl5FIHAWL+iZFM4I=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [
    flit-core
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = lib.optionals (pythonOlder "3.9") [
    astunparse
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  nativeCheckInputs = [
    pytestCheckHook
    coreutils
    jq
    bc
  ];

  pythonImportsCheck = [
    "pyp"
  ];

  meta = with lib; {
    description = "Easily run Python at the shell! Magical, but never mysterious";
    homepage = "https://github.com/hauntsaninja/pyp";
    license = licenses.mit;
    maintainers = with maintainers; [ rmcgibbo ];
   };
}
