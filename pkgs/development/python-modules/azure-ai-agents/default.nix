{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  azure-core,
  isodate,
  typing-extensions,
  azure-cli,
}:

buildPythonPackage rec {
  pname = "azure-ai-agents";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_ai_agents";
    inherit version;
    hash = "sha256-651yJigtAyBsP6s/PuCi/HHgrTjlLS9PGaksVu2VGuo=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    azure-core
    isodate
    typing-extensions
  ];

  pythonImportsCheck = [
    "azure.ai.agents"
  ];

  meta = {
    description = "Microsoft Corporation Azure AI Agents Client Library for Python";
    homepage = "https://pypi.org/project/azure-ai-agents";
    license = lib.licenses.mit;
    maintainers = azure-cli.meta.maintainers;
  };
}
