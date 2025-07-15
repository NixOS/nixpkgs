{
  lib,
  argcomplete,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  importlib-metadata,
  parameterized,
  poetry-core,
  pytest-mock,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
  responses,
  rich,
}:

buildPythonPackage rec {
  pname = "censys";
  version = "2.2.17";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "censys";
    repo = "censys-python";
    tag = "v${version}";
    hash = "sha256-1V7IeaV7Ro1q5UyD2DDetunaRO2L4UbF1VODg5ktqKs=";
  };

  build-system = [ poetry-core ];

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
  ];

  pythonRelaxDeps = [
    "backoff"
    "requests"
    "rich"
  ];

  # The tests want to write a configuration file
  preCheck = ''
    export HOME=$(mktemp -d)
    mkdir -p $HOME
  '';

  pythonImportsCheck = [ "censys" ];

  meta = with lib; {
    description = "Python API wrapper for the Censys Search Engine (censys.io)";
    homepage = "https://github.com/censys/censys-python";
    changelog = "https://github.com/censys/censys-python/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "censys";
  };
}
