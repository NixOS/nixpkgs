{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
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
  version = "0.23.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "huggingface_hub";
    rev = "refs/tags/v${version}";
    hash = "sha256-Nncyi9u72aq1142wBpz3M/ji2GlCbdEqCZ9+kRRnMT4=";
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
