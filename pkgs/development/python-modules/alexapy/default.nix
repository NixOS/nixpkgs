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
, fetchpatch
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
  version = "1.26.8";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitLab {
    owner = "keatontaylor";
    repo = "alexapy";
    rev = "refs/tags/v${version}";
    hash = "sha256-AjtSEqUbJ5e/TZIYMX+pwBSH35tEVrfCA6H/55yrZsk=";
  };

  patches = [
    # Switch to poetry-core, https://gitlab.com/keatontaylor/alexapy/-/merge_requests/342
    (fetchpatch {
      name = "switch-poetry-core.patch";
      url = "https://gitlab.com/keatontaylor/alexapy/-/commit/843daec4ba1fb219f1c4f4a6ca01c9af73014e53.patch";
      hash = "sha256-wlCq0/NJx4Adh/o61FSMWMQU99PZkJ0U2yqxqOfvAa8=";
    })
  ];

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
    changelog = "https://gitlab.com/keatontaylor/alexapy/-/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
