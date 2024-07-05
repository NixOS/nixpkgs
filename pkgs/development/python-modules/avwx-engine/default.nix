{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  geopy,
  hatchling,
  httpx,
  numpy,
  pytest-asyncio,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  rapidfuzz,
  scipy,
  shapely,
  time-machine,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "avwx-engine";
  version = "1.9.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "avwx-rest";
    repo = "avwx-engine";
    rev = "refs/tags/${version}";
    hash = "sha256-CUnUz2SsXtWaqGzaB1PH+EoHqebSue6e8GXhRZRcXLs=";
  };

  postPatch = ''
    sed -i -e "/--cov/d" -e "/--no-cov/d" pyproject.toml
  '';

  build-system = [ hatchling ];

  dependencies = [
    geopy
    httpx
    python-dateutil
    xmltodict
  ];

  passthru.optional-dependencies = {
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
    pytestCheckHook
    time-machine
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

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
    changelog = "https://github.com/avwx-rest/avwx-engine/blob/${version}/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
