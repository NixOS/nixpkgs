{
  lib,
  argcomplete,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  importlib-metadata,
  parameterized,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  requests-mock,
  requests,
  responses,
  rich,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "censys";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "censys";
    repo = "censys-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GBFsAVecUN49vousqnB6enqRsAg1aBrjaA/Q7XXnOUE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    argcomplete
    backoff
    requests
    rich
    importlib-metadata
  ];

  nativeCheckInputs = [
    parameterized
    pytest-mock
    pytest-cov-stub
    pytestCheckHook
    requests-mock
    responses
    writableTmpDirAsHomeHook
  ];

  # The tests want to write a configuration file
  preCheck = ''
    mkdir -p $HOME
  '';

  pythonImportsCheck = [ "censys" ];

  meta = {
    description = "Python API wrapper for the Censys Search Engine (censys.io)";
    homepage = "https://github.com/censys/censys-python";
    changelog = "https://github.com/censys/censys-python/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "censys";
  };
})
