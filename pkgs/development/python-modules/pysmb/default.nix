{ buildPythonPackage
, fetchPypi
, lib

# pythonPackages
, pyasn1
}:

buildPythonPackage rec {
  pname = "pysmb";
  version = "1.2.6";

  src = fetchPypi {
    inherit pname version;
    format = "setuptools";
    extension = "zip";
    sha256 = "f16e5e796b9dcc1d17ee76f87d53dd471f205fa19b4045eeda5bc7558a57d579";
  };

  propagatedBuildInputs = [
    pyasn1
  ];

  # Tests require Network Connectivity and a server up and running
  #   https://github.com/miketeo/pysmb/blob/master/python3/tests/README_1st.txt
  doCheck = false;

  pythonImportsCheck = [ "nmb" "smb" ];

  meta = {
    description = "Experimental SMB/CIFS library written in Python to support file sharing between Windows and Linux machines";
    homepage = "https://miketeo.net/wp/index.php/projects/pysmb";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [
      kamadorueda
    ];
  };
}
