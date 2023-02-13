{ lib
, aiohttp
, aresponses
, buildPythonPackage
, ciso8601
, fetchFromGitHub
, orjson
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiopyarr";
  version = "22.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "tkdrob";
    repo = pname;
    rev = version;
    hash = "sha256-8/ixL4ByaBYoPbB4g+Rgx+5OM6vjrFTUEPR42wBKyyg=";
  };

  propagatedBuildInputs = [
    aiohttp
    ciso8601
    orjson
  ];

  nativeCheckInputs = [
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
