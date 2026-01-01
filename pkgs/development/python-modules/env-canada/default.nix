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

buildPythonPackage rec {
  pname = "env-canada";
<<<<<<< HEAD
  version = "0.12.2";
=======
  version = "0.12.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "michaeldavie";
    repo = "env_canada";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-mv4InXpnNUix+JnupU93o8yeWDqBLschBvCgxlrvlGA=";
=======
    hash = "sha256-DTrlis7YDWk8SNmDBnbHk4XEu+SCrXLPLZMb5f+ynY8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Python library to get Environment Canada weather data";
    homepage = "https://github.com/michaeldavie/env_canada";
    changelog = "https://github.com/michaeldavie/env_canada/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python library to get Environment Canada weather data";
    homepage = "https://github.com/michaeldavie/env_canada";
    changelog = "https://github.com/michaeldavie/env_canada/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
