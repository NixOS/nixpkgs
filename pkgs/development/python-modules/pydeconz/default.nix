{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pydeconz";
  version = "85";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = "deconz";
    rev = "v${version}";
    sha256 = "sha256-6GTMG3BfHcfLMoyabFbhsJFVDHmEICuzf32603+jyZ4=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    aioresponses
    pytest-aiohttp
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
