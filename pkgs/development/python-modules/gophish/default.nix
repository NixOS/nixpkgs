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
  requests,
  setuptools,
  six,
  urllib3,
}:

buildPythonPackage rec {
  pname = "gophish";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gophish";
    repo = "api-client-python";
    tag = "v${version}";
    hash = "sha256-ITwwU/Xixyi9JSWbYf606HB7S5E4jiI0lEYcOdNg3mo=";
  };

  pythonRelaxDeps = true;

  build-system = [ setuptools ];

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

  meta = {
    description = "Module to interact with Gophish";
    homepage = "https://github.com/gophish/api-client-python";
    changelog = "https://github.com/gophish/api-client-python/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
