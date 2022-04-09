{ lib
, aiohttp
, asyncio-throttle
, awesomeversion
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiohue";
  version = "4.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = version;
    hash = "sha256-zXjfPd40yYyAuuW4CmaGRvJuORyQJa+6CFQaO6RQPZo=";
  };

  propagatedBuildInputs = [
    awesomeversion
    aiohttp
    asyncio-throttle
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aiohue"
    "aiohue.discovery"
  ];

  disabledTestPaths = [
    # File are prefixed with test_
    "examples/"
  ];

  meta = with lib; {
    description = "Python package to talk to Philips Hue";
    homepage = "https://github.com/home-assistant-libs/aiohue";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
