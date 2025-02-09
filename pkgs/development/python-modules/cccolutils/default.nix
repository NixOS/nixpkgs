{ lib
, buildPythonPackage
, fetchPypi
, git
, gitpython
, krb5
, mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cccolutils";
  version = "1.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "CCColUtils";
    inherit version;
    hash = "sha256-YzKjG43biRbTZKtzSUHHhtzOfcZfzISHDFolqzrBjL8=";
  };

  buildInputs = [
    krb5
  ];

  propagatedBuildInputs = [
    git
    gitpython
    mock
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cccolutils"
  ];

  meta = with lib; {
    description = "Python Kerberos 5 Credential Cache Collection Utilities";
    homepage = "https://pagure.io/cccolutils";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ disassembler ];
  };
}
