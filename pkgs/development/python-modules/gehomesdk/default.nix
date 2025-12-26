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

buildPythonPackage rec {
  pname = "gehomesdk";
  version = "2025.11.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HS33yTE+3n0DKRD4+cr8zAE+xcW1ca7q8inQ7qwKJMA=";
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
    changelog = "https://github.com/simbaja/gehome/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "gehome-appliance-data";
  };
}
