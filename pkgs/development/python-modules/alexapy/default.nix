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
  version = "1.28.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitLab {
    owner = "keatontaylor";
    repo = "alexapy";
    rev = "refs/tags/v${version}";
    hash = "sha256-sRTK3qaIiYxz9Z+LT2pFjqKXBHyr3EkSD4dtc+KXFQw=";
  };

  pythonRelaxDeps = [ "aiofiles" ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "Python Package for controlling Alexa devices (echo dot, etc) programmatically";
    homepage = "https://gitlab.com/keatontaylor/alexapy";
    changelog = "https://gitlab.com/keatontaylor/alexapy/-/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
