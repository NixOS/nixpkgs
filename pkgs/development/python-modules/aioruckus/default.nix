{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  wheel,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "aioruckus";
  version = "0.34";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "ms264556";
    repo = "aioruckus";
    rev = "refs/tags/v${version}";
    hash = "sha256-SPj1w1jAJFBsWj1+N8srAbvlh+yB3ZTT7aDcZTnmUto=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "setuptools>=68.1" "setuptools"
  '';

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    aiohttp
    xmltodict
  ];

  pythonImportsCheck = [ "aioruckus" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # these require a local ruckus device
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
