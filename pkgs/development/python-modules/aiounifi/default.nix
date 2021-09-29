{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiounifi";
  version = "27";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = pname;
    rev = "v${version}";
    sha256 = "09bxyfrwhqwlfxwgbbnkyd7md9wz05y3fjvc9f0rrj70z7qcicnv";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    aioresponses
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiounifi" ];

  meta = with lib; {
    description = "Python library for communicating with Unifi Controller API";
    homepage = "https://github.com/Kane610/aiounifi";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
