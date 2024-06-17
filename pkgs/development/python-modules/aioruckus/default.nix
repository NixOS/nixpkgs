{
  lib,
  aiohttp,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "aioruckus";
  version = "0.38";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "ms264556";
    repo = "aioruckus";
    rev = "refs/tags/v${version}";
    hash = "sha256-h32EmiCQ6REciGMl0wDV8BSUezsFRo76RqUBeD2+pbY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=68.1" "setuptools"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    cryptography
    xmltodict
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioruckus" ];

  disabledTests = [
    # Those tests require a local ruckus device
    "test_ap_info"
    "test_authentication_error"
    "test_connect_success"
    "test_current_active_clients"
    "test_mesh_info"
    "test_system_info"
  ];

  meta = with lib; {
    description = "Python client for Ruckus Unleashed and Ruckus ZoneDirector";
    homepage = "https://github.com/ms264556/aioruckus";
    license = licenses.bsd0;
    maintainers = with maintainers; [ fab ];
  };
}
