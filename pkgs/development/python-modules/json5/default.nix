{ buildPythonPackage
, fetchFromGitHub
, hypothesis
, lib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "json5";
<<<<<<< HEAD
  version = "0.9.14";
=======
  version = "0.9.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "dpranke";
    repo = "pyjson5";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-cshP1kraLENqWuQTlm4HPAP/0ywRRLFOJI8mteWcjR4=";
=======
    hash = "sha256-0ommoTv5q7YuLNF+ZPWW/Xg/8CwnPrF7rXJ+eS0joUs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "json5"
  ];

  meta = with lib; {
    homepage = "https://github.com/dpranke/pyjson5";
    description = "A Python implementation of the JSON5 data format";
    license = licenses.asl20;
    maintainers = with maintainers; [ veehaitch ];
  };
}
