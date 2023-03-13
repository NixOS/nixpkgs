{ lib
, async-timeout
, asyncstdlib
, attrs
, buildPythonPackage
, defusedxml
, fetchFromGitHub
, httpx
, netifaces
, pytest-asyncio
, pytestCheckHook
, pytest-httpx
, pytest-timeout
, pythonOlder
}:

buildPythonPackage rec {
  pname = "denonavr";
  version = "0.11.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ol-iver";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-iYekqqhrcN1rbclFVSbJSF5ky19WsBLKlTxAa2HULqY=";
  };

  propagatedBuildInputs = [
    asyncstdlib
    attrs
    defusedxml
    httpx
    netifaces
  ] ++ lib.optionals (pythonOlder "3.11") [
    async-timeout
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    pytest-httpx
    pytest-timeout
  ];

  pythonImportsCheck = [
    "denonavr"
  ];

  meta = with lib; {
    description = "Automation Library for Denon AVR receivers";
    homepage = "https://github.com/ol-iver/denonavr";
    changelog = "https://github.com/ol-iver/denonavr/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ colemickens ];
  };
}
