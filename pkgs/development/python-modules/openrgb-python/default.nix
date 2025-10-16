{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "openrgb-python";
  version = "0.3.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-86jy8hoOgQocdCeapjaRFO9PKx/TW9kcN16UKSWNVps=";
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
