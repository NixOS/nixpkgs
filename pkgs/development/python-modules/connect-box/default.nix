{
  lib,
  aiohttp,
  attrs,
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytest-vcr,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "connect-box";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-connect-box";
    tag = finalAttrs.version;
    hash = "sha256-lQfa/GP9XSQJrPBIIR7PZR8F0cmDueTcFDIJTbopRv4=";
  };

  build-system = [ hatchling ];

  dependencies = [
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

  meta = {
    description = "Interact with a Compal CH7465LG cable modem/router";
    longDescription = ''
      Python Client for interacting with the cable modem/router Compal
      CH7465LG which is provided under different names by various ISP
      in Europe, e.g., UPC Connect Box (CH), Irish Virgin Media Super
      Hub 3.0 (IE), Ziggo Connectbox (NL) or Unitymedia Connect Box (DE).
    '';
    homepage = "https://github.com/home-assistant-ecosystem/python-connect-box";
    changelog = "https://github.com/home-assistant-ecosystem/python-connect-box/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
