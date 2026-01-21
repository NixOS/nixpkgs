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
  version = "0.6.1";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IqKJhuAT8UYStqy+2NQ9u4ezHBPum6vNnN42+hq7kZc=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "pymiele" ];

  meta = {
    changelog = "https://github.com/astrandb/pymiele/releases/tag/v${version}";
    description = "Lib for Miele integration with Home Assistant";
    homepage = "https://github.com/astrandb/pymiele";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
}
