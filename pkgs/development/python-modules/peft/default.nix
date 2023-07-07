{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
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
  version = "0.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-7j//SDuld2ANxEcG4R0rK5vEaTX7gQwWRH56PO2KqAY=";
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

  doCheck = false;  # tried to download pretrained model
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
