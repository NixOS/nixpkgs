{
  lib,
  aiohttp,
  beautifulsoup4,
  bidict,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  humanize,
  pytestCheckHook,
  requests,
  setuptools,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "gehomesdk";
  version = "2026.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-+BWGkUDKd+9QGbdXuLjmJxLm1xUv0dpIRlPlDkUJ25w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    beautifulsoup4
    bidict
    humanize
    requests
    websockets
  ];

  nativeCheckInputs = [
    pytestCheckHook
    cryptography
  ];

  pythonImportsCheck = [ "gehomesdk" ];

  meta = {
    description = "Python SDK for GE smart appliances";
    homepage = "https://github.com/simbaja/gehome";
    changelog = "https://github.com/simbaja/gehome/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "gehome-appliance-data";
  };
})
