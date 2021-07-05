{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytest-error-for-skips
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "gios";
  version = "1.0.2";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = version;
    sha256 = "sha256-7+np1lUbBFSTJNAD6OT5k89MM+kzEj90JlulXGm36k8=";
  };

  propagatedBuildInputs = [
    aiohttp
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
