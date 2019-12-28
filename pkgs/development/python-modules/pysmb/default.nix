{ buildPythonPackage
, fetchPypi
, lib

# Python Dependencies
, pythonPackages
}:

buildPythonPackage rec {
  pname = "pysmb";
  version = "1.1.28";

  src = fetchPypi {
    inherit pname version;
    format = "setuptools";
    extension = "zip";
    sha256 = "0x44yq440c1j3xnl7qigz2fpfzhx68n9mbj7ps7rd0kj0plcmr2q";
  };

  propagatedBuildInputs = with pythonPackages; [
    pyasn1
  ];

  doCheck = false;

  meta = {
    description = "pysmb is an experimental SMB/CIFS library written in Python to support file sharing between Windows and Linux machines";
    homepage = "https://miketeo.net/wp/index.php/projects/pysmb";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [
      kamadorueda
    ];
  };
}
