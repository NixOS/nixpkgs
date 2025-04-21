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
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  setuptools,
  syrupy,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "env-canada";
  version = "0.10.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "michaeldavie";
    repo = "env_canada";
    tag = version;
    hash = "sha256-YDosRPROWpjG27MyCErCTvP99mAlzg/GfmU73cBVUTo=";
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
  ];

  pythonImportsCheck = [ "env_canada" ];

  meta = with lib; {
    description = "Python library to get Environment Canada weather data";
    homepage = "https://github.com/michaeldavie/env_canada";
    changelog = "https://github.com/michaeldavie/env_canada/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
