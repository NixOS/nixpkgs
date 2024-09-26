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
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
  responses,
  rich,
}:

buildPythonPackage rec {
  pname = "censys";
  version = "2.2.14";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "censys";
    repo = "censys-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-3evll1Ll8krvAfelGoJHOrmH7RvkeM/ZU1j13cTuXR4=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace-fail "--cov" ""
  '';

  build-system = [
    poetry-core
  ];

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
