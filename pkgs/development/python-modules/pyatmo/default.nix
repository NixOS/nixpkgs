{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  oauthlib,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-oauthlib,
  requests-mock,
  setuptools-scm,
  time-machine,
}:

buildPythonPackage rec {
  pname = "pyatmo";
  version = "9.0.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "jabesq";
    repo = "pyatmo";
    tag = "v${version}";
    hash = "sha256-DGtfXM0Bfo5iyJ66/Bm5rQB2/ZYA+ZhlkUci1viynWY=";
  };

  pythonRelaxDeps = [
    "oauthlib"
    "requests-oauthlib"
    "requests"
  ];

  build-system = [ setuptools-scm ];

  dependencies = [
    aiohttp
    oauthlib
    requests
    requests-oauthlib
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    requests-mock
    time-machine
  ];

  pythonImportsCheck = [ "pyatmo" ];

  meta = with lib; {
    description = "Simple API to access Netatmo weather station data";
    homepage = "https://github.com/jabesq/pyatmo";
    changelog = "https://github.com/jabesq/pyatmo/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
