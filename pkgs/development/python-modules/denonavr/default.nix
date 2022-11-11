{ lib
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
  version = "0.10.12";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "scarface-4711";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-QNiDoPjOuwwAgUqDzXHzn0BE9bwXQrQKAIFlHCywl88=";
  };

  propagatedBuildInputs = [
    asyncstdlib
    attrs
    defusedxml
    httpx
    netifaces
  ];

  checkInputs = [
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
    homepage = "https://github.com/scarface-4711/denonavr";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ colemickens ];
  };
}
