{ lib
, backoff
, buildPythonPackage
, fetchFromGitHub
, importlib-metadata
, parameterized
, poetry-core
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
, responses
, rich
}:

buildPythonPackage rec {
  pname = "censys";
  version = "2.1.3";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "censys";
    repo = "censys-python";
    rev = "v${version}";
    sha256 = "sha256-Zv3ViOrdQby+7UQrHy6174W2qh1vx21R0yOA7ecr0lU=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    backoff
    requests
    rich
    importlib-metadata
  ];

  checkInputs = [
    parameterized
    pytestCheckHook
    requests-mock
    responses
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'backoff = "^1.11.1"' 'backoff = "*"' \
      --replace 'requests = ">=2.26.0"' 'requests = "*"' \
      --replace 'rich = "^10.16.2"' 'rich = "*"'
    substituteInPlace pytest.ini \
      --replace "--cov" ""
  '';

  # The tests want to write a configuration file
  preCheck = ''
    export HOME=$(mktemp -d)
    mkdir -p $HOME
  '';

  pythonImportsCheck = [ "censys" ];

  meta = with lib; {
    description = "Python API wrapper for the Censys Search Engine (censys.io)";
    homepage = "https://github.com/censys/censys-python";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
