{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, geopy
, imageio
, lxml
, pandas
, pillow
, pytestCheckHook
, python-dateutil
, pythonOlder
, voluptuous
}:

buildPythonPackage rec {
  pname = "env-canada";
  version = "0.5.25";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "michaeldavie";
    repo = "env_canada";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-UF04TAhgeb76bYisNYOAraw59K54WkX9a8QOtHywMTQ=";
  };

  propagatedBuildInputs = [
    aiohttp
    geopy
    imageio
    lxml
    pandas
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

  pythonImportsCheck = [
    "env_canada"
  ];

  meta = with lib; {
    description = "Python library to get Environment Canada weather data";
    homepage = "https://github.com/michaeldavie/env_canada";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
