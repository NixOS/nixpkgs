{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  geopy,
  imageio,
  lxml,
  numpy,
  pandas,
  pillow,
  pytest-asyncio,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  setuptools,
  syrupy,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "env-canada";
  version = "0.11.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "michaeldavie";
    repo = "env_canada";
    tag = "v${version}";
    hash = "sha256-r0a2bMgWY6dH88aOJoNpmcSyQi207XDI3Ehu37kU9hY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    geopy
    imageio
    lxml
    numpy
    pandas
    pillow
    python-dateutil
    voluptuous
  ];

  nativeCheckInputs = [
    pytest-asyncio
    freezegun
    pytestCheckHook
    syrupy
  ];

  disabledTests = [
    # Tests require network access
    "test_get_aqhi_regions"
    "test_update"
    "test_get_hydro_sites"
    "test_echydro"
    "test_get_dimensions"
    "test_get_latest_frame"
    "test_get_loop"
    "test_get_ec_sites"
    "test_ecradar"
    "test_historical_number_values"
    "test_basemap_caching_behavior"
    "test_layer_image_caching"
  ];

  pythonImportsCheck = [ "env_canada" ];

  meta = with lib; {
    description = "Python library to get Environment Canada weather data";
    homepage = "https://github.com/michaeldavie/env_canada";
    changelog = "https://github.com/michaeldavie/env_canada/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
