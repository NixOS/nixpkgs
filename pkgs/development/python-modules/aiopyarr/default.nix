{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiopyarr";
  version = "22.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "tkdrob";
    repo = pname;
    rev = version;
    hash = "sha256-nJjqpk4GcgXJhFZd4E3vSmyNP+RkOASEd4Ipemx6cAc=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aiopyarr"
  ];

  meta = with lib; {
    description = "Python API client for Lidarr/Radarr/Readarr/Sonarr";
    homepage = "https://github.com/tkdrob/aiopyarr";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
