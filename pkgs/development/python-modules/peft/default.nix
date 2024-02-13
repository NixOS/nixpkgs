{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
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
  version = "0.7.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-sdv9rMj5Qh2/QtBVSxHMAP/Tk+ZyrHtNfX/4q8/Qw3A=";
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

  doCheck = false;  # tries to download pretrained models
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
