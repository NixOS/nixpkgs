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

buildPythonPackage (finalAttrs: {
  pname = "alexapy";
  version = "1.29.16";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "keatontaylor";
    repo = "alexapy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SjY9xl/ogs7sxYo/NrcAezLDO703XAdK4d6Vv+qvYn0=";
  };

  pythonRelaxDeps = [ "aiofiles" ];

  build-system = [ poetry-core ];

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
    changelog = "https://gitlab.com/keatontaylor/alexapy/-/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
