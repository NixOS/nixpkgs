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
  version = "0.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "scarface-4711";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-0zclIoEGKjA8Ro8k+HYX/d77U+ntQZv0vq6gC4Sa7zE=";
  };

  propagatedBuildInputs = [
    asyncstdlib
    attrs
    defusedxml
    httpx
    netifaces
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
    homepage = "https://github.com/scarface-4711/denonavr";
    changelog = "https://github.com/ol-iver/denonavr/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ colemickens ];
  };
}
