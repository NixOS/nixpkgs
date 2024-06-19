{
  lib,
  appdirs,
  buildPythonPackage,
  certifi,
  chardet,
  fetchFromGitHub,
  idna,
  packaging,
  pyparsing,
  python-dateutil,
  pythonOlder,
  pythonRelaxDepsHook,
  requests,
  setuptools,
  six,
  urllib3,
}:

buildPythonPackage rec {
  pname = "gophish";
  version = "0.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "gophish";
    repo = "api-client-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-ITwwU/Xixyi9JSWbYf606HB7S5E4jiI0lEYcOdNg3mo=";
  };

  pythonRelaxDeps = true;

  build-system = [ setuptools ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  dependencies = [
    appdirs
    certifi
    chardet
    idna
    packaging
    pyparsing
    python-dateutil
    requests
    six
    urllib3
  ];

  pythonImportsCheck = [ "gophish" ];

  # Module has no test
  doCheck = false;

  meta = with lib; {
    description = "Module to interact with Gophish";
    homepage = "https://github.com/gophish/api-client-python";
    changelog = "https://github.com/gophish/api-client-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
