{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nskeyedunarchiver";
  version = "1.5.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2aLV1I6p4seNMb+/xKl8AnlBkvO0VINC1yfVS90gvro=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "NSKeyedUnArchiver" ];

  meta = {
    description = "Unserializes plist data into a usable Python dict";
    homepage = "https://github.com/avibrazil/NSKeyedUnArchiver";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ PapayaJackal ];
  };
}
