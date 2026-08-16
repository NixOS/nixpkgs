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

buildPythonPackage (finalAttrs: {
  pname = "avwx-engine";
  version = "1.9.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "avwx-rest";
    repo = "avwx-engine";
    tag = finalAttrs.version;
    hash = "sha256-RJOXMbbBdcuWvNcQUGq5VHCpdWOVQoBjruQ96m1f1gc=";
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
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "avwx" ];

  disabledTests = [
    # Tests require network access
    "fetch"
    "test_nbm_all"
    "test_station_nearest_ip"
  ];

  meta = {
    description = "Aviation Weather parsing engine";
    homepage = "https://github.com/avwx-rest/avwx-engine";
    changelog = "https://github.com/avwx-rest/avwx-engine/blob/${finalAttrs.src.tag}/changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
