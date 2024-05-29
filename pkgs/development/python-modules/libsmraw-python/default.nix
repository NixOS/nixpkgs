{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "libsmraw-python";
  version = "20240310";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-m51g5B1c5dn2rSatMjWaztVqFSqQTiolAjvMbauVHkM=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pysmraw" ];

  meta = with lib; {
    changelog = "https://github.com/libyal/libsmraw/releases/tag/${version}";
    description = "Python bindings module for libsmraw";
    downloadPage = "https://github.com/libyal/libsmraw/releases";
    homepage = "https://github.com/libyal/libsmraw";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
