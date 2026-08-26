{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  huggingface-hub,
  kernels-data,
  setuptools,
  sigstore,
  tomlkit,
}:

buildPythonPackage (finalAttrs: {
  pname = "kernels";
  version = "0.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "kernels";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mrPGykU07PwelebEitr0HDZemZ8WzBhMflBBirQnzAQ=";
  };

  sourceRoot = "${finalAttrs.src.name}/${finalAttrs.pname}";

  build-system = [ setuptools ];

  dependencies = [
    huggingface-hub
    kernels-data
    sigstore
    tomlkit
  ];

  # Tests require pervasive internet access
  doCheck = false;

  pythonImportsCheck = [ "kernels" ];

  meta = {
    description = "Load compute kernels from the Huggingface Hub";
    homepage = "https://github.com/huggingface/kernels";
    changelog = "https://github.com/huggingface/kernels/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ osbm ];
  };
})
