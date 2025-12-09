{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyasn1,
  pythonOlder,
  tqdm,
}:

buildPythonPackage rec {
  pname = "pysmb";
  version = "1.2.13";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "miketeo";
    repo = "pysmb";
    tag = "pysmb-${version}";
    hash = "sha256-CLjpUkDCtAZyneM+KFTE1G1Q3NIRRw2sIytIv30ZUgI=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
    description = "Experimental SMB/CIFS library to support file sharing between Windows and Linux machines";
    homepage = "https://pysmb.readthedocs.io/";
    changelog = "https://github.com/miketeo/pysmb/releases/tag/${src.tag}";
    license = licenses.zlib;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
