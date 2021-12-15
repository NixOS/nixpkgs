{ lib
, aiohttp
, asynctest
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pymelcloud";
  version = "2.5.6";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "vilppuvuorinen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QXOL3MftNibo1wUjz/KTQLNDk7pWL9VH/wd7LpEJOmE=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    asynctest
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pymelcloud"
  ];

  meta = with lib; {
    description = "Python module for interacting with MELCloud";
    homepage = "https://github.com/vilppuvuorinen/pymelcloud";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
