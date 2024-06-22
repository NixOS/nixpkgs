{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  geopy,
  imageio,
  lxml,
  pandas,
  pillow,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  setuptools,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "env-canada";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "michaeldavie";
    repo = "env_canada";
    rev = "refs/tags/v${version}";
    hash = "sha256-ND1QObDdn6tBGNlnnVadNv6ibYYpOoo2HZEXIMlfwyc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    geopy
    imageio
    lxml
    pandas
    pillow
    python-dateutil
    voluptuous
  ];

  nativeCheckInputs = [ pytestCheckHook ];

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
  ];

  pythonImportsCheck = [ "env_canada" ];

  meta = with lib; {
    description = "Python library to get Environment Canada weather data";
    homepage = "https://github.com/michaeldavie/env_canada";
    changelog = "https://github.com/michaeldavie/env_canada/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
