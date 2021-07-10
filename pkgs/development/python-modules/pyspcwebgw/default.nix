{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiohttp
, asynccmd
, aioresponses
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyspcwebgw";
  version = "0.5.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mbrrg";
    repo = "pyspcwebgw";
    rev = "v${version}";
    sha256 = "0pc25myjc2adqcx2lbns9kw0gy17x1qjgicmfj46n6fn0c786p9v";
  };

  propagatedBuildInputs = [
    aiohttp
    asynccmd
  ];

  checkInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyspcwebgw" ];

  meta = with lib; {
    description = "Python library for communicating with SPC Web Gateway";
    homepage = "https://github.com/mbrrg/pyspcwebgw";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
