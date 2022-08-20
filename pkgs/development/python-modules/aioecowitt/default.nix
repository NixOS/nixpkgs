{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, meteocalc
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioecowitt";
  version = "2022.08.2";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-y0oPEsCW3jdd7jzBelCsUnrvDpzxP+Dtb/pQRrGTYDQ=";
  };

  propagatedBuildInputs = [
    aiohttp
    meteocalc
  ];

  checkInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aioecowitt"
  ];

  meta = with lib; {
    description = "Wrapper for the EcoWitt protocol";
    homepage = "https://github.com/home-assistant-libs/aioecowitt";
    changelog = "https://github.com/home-assistant-libs/aioecowitt/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
