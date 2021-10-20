{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, dacite
, fetchFromGitHub
, pytest-asyncio
, pytest-error-for-skips
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "gios";
  version = "2.1.0";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = version;
    sha256 = "sha256-WjuDsu0EA+KtErusw5VADyvleVegXHCTEkuQ1lU/SRU=";
  };

  propagatedBuildInputs = [
    aiohttp
    dacite
  ];

  checkInputs = [
    aioresponses
    pytest-asyncio
    pytest-error-for-skips
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov --cov-report term-missing " ""
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  disabledTests = [
    # Test requires network access
    "test_invalid_station_id"
  ];

  pythonImportsCheck = [ "gios" ];

  meta = with lib; {
    description = "Python client for getting air quality data from GIOS";
    homepage = "https://github.com/bieniu/gios";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
