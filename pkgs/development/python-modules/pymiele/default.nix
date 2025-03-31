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
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/iUpbvD77MURTltnStm47PEqXnfVuHf4m3+h9V2cn68=";
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
