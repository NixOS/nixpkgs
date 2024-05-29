{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  zlib,
  ...
}:
buildPythonPackage rec {
  pname = "libmodi-python";
  version = "20240305";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cZy1/RdFbT6OwIT/+MCVpdzRO8sz0P3I6EtcI9HdfNI=";
  };

  build-system = [ setuptools ];

  buildInputs = [ zlib ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pymodi" ];

  meta = with lib; {
    changelog = "https://github.com/libyal/libmodi/releases/tag/${version}";
    description = "Python bindings module for libmodi";
    downloadPage = "https://github.com/libyal/libmodi/releases";
    homepage = "https://github.com/libyal/libmodi";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
