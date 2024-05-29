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
  pname = "libfshfs-python";
  version = "20240221";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7iSD02FCbgClPIbyK2jxbdpX91ccpUt+J0QTnPcSmbM=";
  };

  build-system = [ setuptools ];

  buildInputs = [ zlib ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyfshfs" ];

  meta = with lib; {
    changelog = "https://github.com/libyal/libfshfs/releases/tag/${version}";
    description = "Python bindings module for libfshfs";
    downloadPage = "https://github.com/libyal/libfshfs/releases";
    homepage = "https://github.com/libyal/libfshfs";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
