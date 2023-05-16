{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
<<<<<<< HEAD
=======
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, setuptools
, numpy
, packaging
, psutil
, pyyaml
, torch
, transformers
, accelerate
}:

buildPythonPackage rec {
  pname = "peft";
<<<<<<< HEAD
  version = "0.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "0.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-FaD873ksim7ewOI6Wqcv+GuPmH45+yAvbJC1H/DSfI8=";
=======
    hash = "sha256-NPpY29HMQe5KT0JdlLAXY9MVycDslbP2i38NSTirB3I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    numpy
    packaging
    psutil
    pyyaml
    torch
    transformers
    accelerate
  ];

<<<<<<< HEAD
  doCheck = false;  # tries to download pretrained models
=======
  doCheck = false;  # tried to download pretrained model
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "peft"
  ];

  meta = with lib; {
    homepage = "https://github.com/huggingface/peft";
    description = "State-of-the art parameter-efficient fine tuning";
    changelog = "https://github.com/huggingface/peft/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
