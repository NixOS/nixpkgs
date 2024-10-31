{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "openrgb-python";
  version = "0.3.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-euWcot6OfGOSzueA3B4L3h+G2Gv97ZZUiSTABQh8kSc=";
  };

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "openrgb" ];

  meta = with lib; {
    description = "Module for the OpenRGB SDK";
    homepage = "https://openrgb-python.readthedocs.io/";
    changelog = "https://github.com/jath03/openrgb-python/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
