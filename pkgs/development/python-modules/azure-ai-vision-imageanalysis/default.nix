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
  version = "37.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-python";
    tag = "azure-mgmt-containerservice_${version}";
    hash = "sha256-jJInBc+G+OQPF2lIQFzhIo8SbZHam7FaiTwh7WvBF+o=";
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
