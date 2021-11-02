{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, geopy
, imageio
, lxml
, pillow
, pytestCheckHook
, python-dateutil
, voluptuous
}:

buildPythonPackage rec {
  pname = "env-canada";
  version = "0.5.15";

  src = fetchFromGitHub {
    owner = "michaeldavie";
    repo = "env_canada";
    rev = "v${version}";
    sha256 = "1mgh4sbibgwzrgnlfz4ia2djlyniq7b6f9bd9f2yd1wkai32dm2a";
  };

  propagatedBuildInputs = [
    aiohttp
    geopy
    imageio
    lxml
    pillow
    python-dateutil
    voluptuous
  ];

  checkInputs = [
    pytestCheckHook
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
  ];

  pythonImportsCheck = [ "env_canada" ];

  meta = with lib; {
    description = "Python library to get Environment Canada weather data";
    homepage = "https://github.com/michaeldavie/env_canada";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
