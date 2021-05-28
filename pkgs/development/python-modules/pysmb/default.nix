{ buildPythonPackage
, fetchPypi
, lib

# pythonPackages
, pyasn1
}:

buildPythonPackage rec {
  pname = "pysmb";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    format = "setuptools";
    extension = "zip";
    sha256 = "59ccd07537fb2a630b0d8cccd78e80180bcca72150d7322c318e1bdae927e125";
  };

  propagatedBuildInputs = [
    pyasn1
  ];

  # Tests require Network Connectivity and a server up and running
  #   https://github.com/miketeo/pysmb/blob/master/python3/tests/README_1st.txt
  doCheck = false;

  meta = {
    description = "Experimental SMB/CIFS library written in Python to support file sharing between Windows and Linux machines";
    homepage = "https://miketeo.net/wp/index.php/projects/pysmb";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [
      kamadorueda
    ];
  };
}
