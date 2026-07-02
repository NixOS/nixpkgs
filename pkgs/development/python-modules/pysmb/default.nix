{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyasn1,
  tqdm,
}:

buildPythonPackage rec {
  pname = "pysmb";
  version = "1.2.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "miketeo";
    repo = "pysmb";
    tag = "pysmb-${version}";
    hash = "sha256-TwQ9gkhZ9nMyr30qJ9QVX3PPUtSPcxxBzKZr7Z7d9l8=";
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

  meta = {
    description = "Experimental SMB/CIFS library to support file sharing between Windows and Linux machines";
    homepage = "https://pysmb.readthedocs.io/";
    changelog = "https://github.com/miketeo/pysmb/releases/tag/${src.tag}";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
}
