{
  lib,
  aiohttp,
  attrs,
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
  pythonOlder,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  pytest-vcr,
  syrupy,
}:

buildPythonPackage rec {
  pname = "connect-box";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-connect-box";
    rev = "refs/tags/${version}";
    hash = "sha256-zUvZRnxVzg9izvUbp7QVcyu6Bw3dUXHOr0kOQRWEZVc=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    aiohttp
    attrs
    defusedxml
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    pytest-vcr
    syrupy
  ];

  pythonImportsCheck = [ "connect_box" ];

  pytestFlagsArray = [ "--vcr-record=none" ];

  meta = with lib; {
    description = "Interact with a Compal CH7465LG cable modem/router";
    longDescription = ''
      Python Client for interacting with the cable modem/router Compal
      CH7465LG which is provided under different names by various ISP
      in Europe, e.g., UPC Connect Box (CH), Irish Virgin Media Super
      Hub 3.0 (IE), Ziggo Connectbox (NL) or Unitymedia Connect Box (DE).
    '';
    homepage = "https://github.com/home-assistant-ecosystem/python-connect-box";
    changelog = "https://github.com/home-assistant-ecosystem/python-connect-box/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
