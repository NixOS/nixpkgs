{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pymiele";
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-X2nATBOOq+N4ptF2NCNbZLi2KweoMzw0ixwP5mXm9SI=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "pymiele" ];

  meta = with lib; {
    changelog = "https://github.com/astrandb/pymiele/releases/tag/v${version}";
    description = "Lib for Miele integration with Home Assistant";
    homepage = "https://github.com/astrandb/pymiele";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
