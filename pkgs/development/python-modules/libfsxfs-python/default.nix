{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "libfsxfs-python";
  version = "20240222";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s5W6rGh+WbFGf7uIU4Cy38EumdMu7GdWHxxBpAN3x5c=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyfsxfs" ];

  meta = with lib; {
    changelog = "https://github.com/libyal/libfsxfs/releases/tag/${version}";
    description = "Python bindings module for libfsxfs";
    downloadPage = "https://github.com/libyal/libfsxfs/releases";
    homepage = "https://github.com/libyal/libfsxfs";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
