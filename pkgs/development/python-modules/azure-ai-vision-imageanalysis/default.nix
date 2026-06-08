{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  azure-core,
  isodate,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-ai-vision-imageanalysis";
  version = "41.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-python";
    tag = "azure-mgmt-containerservice_${finalAttrs.version}";
    hash = "sha256-15YMJA5uNCmBTzslzZKS3ITqPnN5lY0vpwEY4zIj/X0=";
  };

  sourceRoot = "${finalAttrs.src.name}/sdk/vision/azure-ai-vision-imageanalysis";

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
})
