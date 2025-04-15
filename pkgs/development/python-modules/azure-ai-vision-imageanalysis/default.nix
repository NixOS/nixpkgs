{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  azure-core,
  isodate,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-ai-vision-imageanalysis";
  version = "1.0.0b3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-python";
    tag = "azure-ai-vision-imageanalysis_${version}";
    hash = "sha256-Hkj9mrjCc8Li8z6e1BjpzANRVx6+DjN0MhTLANMT78E=";
  };

  sourceRoot = "${src.name}/sdk/vision/azure-ai-vision-imageanalysis";

  build-system = [ setuptools ];

  dependencies = [
    azure-core
    isodate
    typing-extensions
  ];

  pythonImportsCheck = [ "azure.ai.vision.imageanalysis" ];

  doCheck = false; # cannot import 'devtools_testutils'

  meta = {
    description = "Azure Image Analysis client library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/vision/azure-ai-vision-imageanalysis";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
