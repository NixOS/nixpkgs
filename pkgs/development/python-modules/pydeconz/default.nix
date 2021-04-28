{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pydeconz";
  version = "78";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = "deconz";
    rev = "v${version}";
    sha256 = "sha256-uIRuLNGFX7gq59/ntfks9pECiGkX7jjKh2jmjxFRcv4=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pydeconz" ];

  meta = with lib; {
    description = "Python library wrapping the Deconz REST API";
    homepage = "https://github.com/Kane610/deconz";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
