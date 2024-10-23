{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  NSKeyedUnArchiver,
  pycrypto,
}:

buildPythonPackage rec {
  pname = "iOSbackup";
  version = "0.9.925";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-M1Rakknls/qq3x7ngv5r3823D64N77oazuM2pl+T0co=";
  };

  propagatedBuildInputs = [
    pycrypto
    NSKeyedUnArchiver
  ];

  meta = {
    description = "Reads and extracts files from password-encrypted iOS backups";
    homepage = "https://github.com/avibrazil/iOSbackup";
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ PapayaJackal ];
  };
}
