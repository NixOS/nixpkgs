{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  geopy,
  httpx,
  numpy,
  poetry-core,
  pytestCheckHook,
  pytest-asyncio,
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
  version = "1.8.28";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "avwx-rest";
    repo = "avwx-engine";
    rev = "refs/tags/${version}";
    hash = "sha256-sxOLhcmTJg/dTrtemr9BcfcBoHTP1eGo8U1ab8iSvUM=";
  };

  postPatch = ''
    sed -i -e "/--cov/d" -e "/--no-cov/d" pyproject.toml
  '';

  build-system = [ poetry-core ];

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
