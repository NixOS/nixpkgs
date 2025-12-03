{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  geopy,
  hatchling,
  httpx,
  numpy,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  python-dateutil,
  rapidfuzz,
  scipy,
  shapely,
  time-machine,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "avwx-engine";
  version = "1.9.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "avwx-rest";
    repo = "avwx-engine";
    tag = version;
    hash = "sha256-j+WT0v1h+dOGW90u+LIVQ0xIE4YzsWRo2E0mGOZUU1A=";
  };

  build-system = [ hatchling ];

  dependencies = [
    geopy
    httpx
    python-dateutil
    xmltodict
  ];

  optional-dependencies = {
    all = [
      numpy
      rapidfuzz
      scipy
      shapely
    ];
    fuzz = [ rapidfuzz ];
    scipy = [
      numpy
      scipy
    ];
    shape = [ shapely ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    time-machine
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "avwx" ];

  disabledTests = [
    # Tests require network access
    "fetch"
    "test_nbm_all"
    "test_station_nearest_ip"
  ];

  meta = with lib; {
    description = "Aviation Weather parsing engine";
    homepage = "https://github.com/avwx-rest/avwx-engine";
    changelog = "https://github.com/avwx-rest/avwx-engine/blob/${src.tag}/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
