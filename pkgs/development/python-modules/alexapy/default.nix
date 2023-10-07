{ lib
, aiofiles
, aiohttp
, authcaptureproxy
, backoff
, beautifulsoup4
, buildPythonPackage
, certifi
, cryptography
, fetchFromGitLab
, poetry-core
, pyotp
, pythonOlder
, pythonRelaxDepsHook
, requests
, simplejson
, yarl
}:

buildPythonPackage rec {
  pname = "alexapy";
  version = "1.27.4";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitLab {
    owner = "keatontaylor";
    repo = "alexapy";
    rev = "refs/tags/v${version}";
    hash = "sha256-Z7h6VX4cwcepo0Kxq9GdHv+XFNg/0s/OhJ/iHubhovs=";
  };

  pythonRelaxDeps = [
    "aiofiles"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
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

  pythonImportsCheck = [
    "alexapy"
  ];

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
