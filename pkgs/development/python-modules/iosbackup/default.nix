{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  nskeyedunarchiver,
  pycrypto,
}:

buildPythonPackage rec {
  pname = "iosbackup";
  version = "0.9.925";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "iOSbackup";
    hash = "sha256-M1Rakknls/qq3x7ngv5r3823D64N77oazuM2pl+T0co=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pycrypto
    nskeyedunarchiver
  ];

  pythonImportsCheck = [ "iOSbackup" ];

  meta = {
    description = "Reads and extracts files from password-encrypted iOS backups";
    homepage = "https://github.com/avibrazil/iOSbackup";
    license = lib.licenses.lgpl2Only;
    maintainers = with lib.maintainers; [ PapayaJackal ];
  };
}
