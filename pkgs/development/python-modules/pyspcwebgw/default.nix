{ lib
, aiohttp
, aioresponses
, asynccmd
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "pyspcwebgw";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mbrrg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0pc25myjc2adqcx2lbns9kw0gy17x1qjgicmfj46n6fn0c786p9v";
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

  pythonImportsCheck = [ "pyspcwebgw" ];

  meta = with lib; {
    description = "Python module for the SPC Web Gateway REST API";
    homepage = "https://github.com/mbrrg/pyspcwebgw";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
