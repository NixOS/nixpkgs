{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  filelock,
  fsspec,
  packaging,
  pyyaml,
  requests,
  tqdm,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "huggingface-hub";
  version = "0.29.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "huggingface_hub";
    tag = "v${version}";
    hash = "sha256-7KP40p7ULWOrkI62DSjmOgrQ0AdX++z+WaLy93L+3WY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    filelock
    fsspec
    packaging
    pyyaml
    requests
    tqdm
    typing-extensions
  ];

  # Tests require network access.
  doCheck = false;

  pythonImportsCheck = [ "huggingface_hub" ];

  meta = {
    description = "Download and publish models and other files on the huggingface.co hub";
    mainProgram = "huggingface-cli";
    homepage = "https://github.com/huggingface/huggingface_hub";
    changelog = "https://github.com/huggingface/huggingface_hub/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
