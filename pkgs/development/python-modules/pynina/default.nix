{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pynina";
  version = "0.3.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyNINA";
    inherit version;
    hash = "sha256-/BeT05dHPHfqybsly0QUbBPFFJKEr67vG1xbBfZXQuY=";
  };

  pythonRelaxDeps = [ "aiohttp" ];

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pynina" ];

  meta = with lib; {
    description = "Python API wrapper to retrieve warnings from the german NINA app";
    homepage = "https://gitlab.com/DeerMaximum/pynina";
    changelog = "https://gitlab.com/DeerMaximum/pynina/-/releases/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
