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
  version = "1.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-python";
    tag = "azure-ai-vision-imageanalysis_${finalAttrs.version}";
    hash = "sha256-gkOKD7koHmsApnylnlQ+/PkbhyUKwigeawznPlU1jvM=";
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
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/${finalAttrs.src.tag}/sdk/vision/azure-ai-vision-imageanalysis/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
