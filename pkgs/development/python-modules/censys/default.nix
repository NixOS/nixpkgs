{ lib
, argcomplete
, backoff
, buildPythonPackage
, fetchFromGitHub
, importlib-metadata
, parameterized
, poetry-core
, pytest-mock
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, requests
, requests-mock
, responses
, rich
}:

buildPythonPackage rec {
  pname = "censys";
  version = "2.2.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "censys";
    repo = "censys-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-awe/6d6AryihS8vYCRtU8APbLUsqv9aKULBmjjaz3gM=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
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

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov" ""
  '';

  # The tests want to write a configuration file
  preCheck = ''
    export HOME=$(mktemp -d)
    mkdir -p $HOME
  '';

  pythonImportsCheck = [
    "censys"
  ];

  meta = with lib; {
    description = "Python API wrapper for the Censys Search Engine (censys.io)";
    homepage = "https://github.com/censys/censys-python";
    changelog = "https://github.com/censys/censys-python/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
