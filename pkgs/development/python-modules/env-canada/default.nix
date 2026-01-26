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
  setuptools,
  syrupy,
  voluptuous,
}:

buildPythonPackage (finalAttrs: {
  pname = "env-canada";
  version = "0.12.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "michaeldavie";
    repo = "env_canada";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2ajvBGgYf5xhygv2h9RzkhkedXm+6QJmPczLJ42hqMA=";
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

  meta = {
    description = "Python library to get Environment Canada weather data";
    homepage = "https://github.com/michaeldavie/env_canada";
    changelog = "https://github.com/michaeldavie/env_canada/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
