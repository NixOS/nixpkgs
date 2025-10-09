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
  version = "0.5.5";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-C1E5z/h4XCDhUP07EL8s6Xv++M03vx8KZOMjWySyUMw=";
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
