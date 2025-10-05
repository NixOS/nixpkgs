{
  lib,
  aiofiles,
  aiohttp,
  authcaptureproxy,
  backoff,
  beautifulsoup4,
  buildPythonPackage,
  certifi,
  cryptography,
  fetchFromGitLab,
  poetry-core,
  pyotp,
  pythonOlder,
  requests,
  simplejson,
  yarl,
}:

buildPythonPackage rec {
  pname = "alexapy";
  version = "1.29.8";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitLab {
    owner = "keatontaylor";
    repo = "alexapy";
    tag = "v${version}";
    hash = "sha256-AmczPJK7v1ymRT3XUUNzFR8GmDr9eZYGRH2FL3RvPsE=";
  };

  pythonRelaxDeps = [ "aiofiles" ];

  build-system = [
    poetry-core
  ];

  dependencies = [
    aiofiles
    aiohttp
    authcaptureproxy
    backoff
    beautifulsoup4
    certifi
    cryptography
    pyotp
    requests
    simplejson
    yarl
  ];

  pythonImportsCheck = [ "alexapy" ];

  # Module has no tests (only a websocket test which seems unrelated to the module)
  doCheck = false;

  meta = {
    description = "Python Package for controlling Alexa devices (echo dot, etc) programmatically";
    homepage = "https://gitlab.com/keatontaylor/alexapy";
    changelog = "https://gitlab.com/keatontaylor/alexapy/-/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
