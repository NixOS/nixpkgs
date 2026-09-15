{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  huggingface-hub,
  kernels-data,
  packaging,
  pythonOlder,
  pyyaml,
  setuptools,
  sigstore,
  tomli,
  tomlkit,
  typing-extensions,
}:
buildPythonPackage rec {
  pname = "kernels";
  version = "0.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "kernels";
    tag = "v${version}";
    hash = "sha256-mrPGykU07PwelebEitr0HDZemZ8WzBhMflBBirQnzAQ=";
  };

  sourceRoot = "${src.name}/kernels";

  build-system = [
    setuptools
  ];

  dependencies = [
    huggingface-hub
    kernels-data
    packaging
    pyyaml
    sigstore
    tomlkit
  ]
  ++ lib.optionals (pythonOlder "3.11") [
    tomli
    typing-extensions
  ];

  # Tests require pervasive internet access
  doCheck = false;

  pythonImportsCheck = [ "kernels" ];

  meta = {
    description = "Load compute kernels from the Huggingface Hub";
    homepage = "https://github.com/huggingface/kernels";
    changelog = "https://github.com/huggingface/kernels/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ osbm ];
  };
}
