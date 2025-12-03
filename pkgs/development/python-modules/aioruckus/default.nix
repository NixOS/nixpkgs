{
  lib,
  aiohttp,
  aioresponses,
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
  version = "0.42";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "ms264556";
    repo = "aioruckus";
    tag = "v${version}";
    hash = "sha256-UfyB3qGEDOQ39YA1AueCBXeoJhGH+XDCLZSFA+kpT2k=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    cryptography
    xmltodict
  ];

  nativeCheckInputs = [
    aioresponses
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
    # Network access to Ruckus Cloud API
    "test_r1_connect_no_webserver_error"
  ];

  meta = with lib; {
    description = "Python client for Ruckus Unleashed and Ruckus ZoneDirector";
    homepage = "https://github.com/ms264556/aioruckus";
    license = licenses.bsd0;
    maintainers = with maintainers; [ fab ];
  };
}
