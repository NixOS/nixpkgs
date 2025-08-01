{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-command-r,
  cohere,
  pytestCheckHook,
  pytest-recording,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "llm-command-r";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-command-r";
    tag = version;
    hash = "sha256-PxICRds9NJQP64HwoL7Oxd39yaIrMdAyQEbhaumJCgo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cohere
    llm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-recording
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_command_r" ];

  passthru.tests = llm.mkPluginTest llm-command-r;

  meta = {
    description = "Access the Cohere Command R family of models";
    homepage = "https://github.com/simonw/llm-command-r";
    changelog = "https://github.com/simonw/llm-command-r/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
