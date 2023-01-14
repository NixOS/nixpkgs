{ lib
, buildPythonPackage
, fetchFromGitHub
, pyasn1
, pythonOlder
, tqdm
}:

buildPythonPackage rec {
  pname = "pysmb";
  version = "1.2.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "miketeo";
    repo = "pysmb";
    rev = "refs/tags/pysmb-${version}";
    hash = "sha256-2AZAtypotSVXWfwokUpfWYQMiMq6EgbdBx2G7bU0Cqw=";
  };

  propagatedBuildInputs = [
    pyasn1
    tqdm
  ];

  # Tests require Network Connectivity and a server up and running
  # https://github.com/miketeo/pysmb/blob/master/python3/tests/README_1st.txt
  doCheck = false;

  pythonImportsCheck = [
    "nmb"
    "smb"
  ];

  meta = with lib; {
    changelog = "https://github.com/miketeo/pysmb/releases/tag/pysmb-${version}";
    description = "Experimental SMB/CIFS library written in Python to support file sharing between Windows and Linux machines";
    homepage = "https://miketeo.net/wp/index.php/projects/pysmb";
    license = licenses.zlib;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
