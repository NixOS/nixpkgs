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
  requests,
  simplejson,
  yarl,
}:

buildPythonPackage rec {
  pname = "alexapy";
  version = "1.29.11";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "keatontaylor";
    repo = "alexapy";
    tag = "v${version}";
    hash = "sha256-czg3g1dsHBQbbSeXmLrU28eo66Ph9FYx/q4nyR2BZL4=";
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
    changelog = "https://gitlab.com/keatontaylor/alexapy/-/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
