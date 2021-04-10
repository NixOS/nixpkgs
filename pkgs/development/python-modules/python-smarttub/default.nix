{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, inflection
, pyjwt
, pytest-asyncio
, pytestCheckHook
, python-dateutil
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-smarttub";
  version = "0.0.23";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mdz";
    repo = pname;
    rev = "v${version}";
    sha256 = "0maqbmk50xjhv9f0zm62ayzyf99kic3c0g5714cqkw3pfp8k75cx";
  };

  propagatedBuildInputs = [
    aiohttp
    inflection
    pyjwt
    python-dateutil
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "smarttub" ];

  meta = with lib; {
    description = "Python API for SmartTub enabled hot tubs";
    homepage = "https://github.com/mdz/python-smarttub";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
