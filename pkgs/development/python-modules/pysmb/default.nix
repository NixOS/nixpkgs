{ lib
, buildPythonPackage
, fetchPypi
, pyasn1
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysmb";
  version = "1.2.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    format = "setuptools";
    extension = "zip";
    hash = "sha256-OwfbFiF0ZQOdDCVpTAcFuDZjyoIlniCfNWbVd1Nqc5U=";
  };

  propagatedBuildInputs = [
    pyasn1
  ];

  # Tests require Network Connectivity and a server up and running
  # https://github.com/miketeo/pysmb/blob/master/python3/tests/README_1st.txt
  doCheck = false;

  pythonImportsCheck = [
    "nmb"
    "smb"
  ];

  meta = with lib; {
    description = "Experimental SMB/CIFS library written in Python to support file sharing between Windows and Linux machines";
    homepage = "https://miketeo.net/wp/index.php/projects/pysmb";
    license = licenses.zlib;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
