{ lib
, aiohttp
, aioresponses
, asynccmd
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyspcwebgw";
  version = "0.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mbrrg";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Pjv8AxXuwi48Z8U+LSZZ+OhXrE3KlX7jlmnXTBLxXOs=";
  };

  propagatedBuildInputs = [
    asynccmd
    aiohttp
  ];

  checkInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=legacy"
  ];

  pythonImportsCheck = [ "pyspcwebgw" ];

  meta = with lib; {
    description = "Python module for the SPC Web Gateway REST API";
    homepage = "https://github.com/mbrrg/pyspcwebgw";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
