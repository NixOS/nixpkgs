{ lib
, buildPythonPackage
, fetchPypi
, samba
, pkg-config
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysmbc";
  version = "1.0.24";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zq3o1hHmPXKnXSYrNCptyDa2+AqzjqX9WtRD4ve+LO0=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    samba
  ];

  # Tests would require a local SMB server
  doCheck = false;

  pythonImportsCheck = [
    "smbc"
  ];

  meta = with lib; {
    description = "libsmbclient binding for Python";
    homepage = "https://github.com/hamano/pysmbc";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
