{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  numpy,
  packaging,
  psutil,
  pyyaml,
  torch,
  transformers,
  accelerate,
}:

buildPythonPackage rec {
  pname = "peft";
  version = "0.14.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-Bo8nqhxL6st/Nk9wSqly7FH+RNkT0baB+1bbTIolUis=";
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

  doCheck = false; # tries to download pretrained models
  pythonImportsCheck = [ "peft" ];

  meta = with lib; {
    homepage = "https://github.com/huggingface/peft";
    description = "State-of-the art parameter-efficient fine tuning";
    changelog = "https://github.com/huggingface/peft/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
