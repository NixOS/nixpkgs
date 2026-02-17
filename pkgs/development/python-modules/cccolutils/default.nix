{
  lib,
  buildPythonPackage,
  fetchPypi,
  git,
  gitpython,
  krb5-c, # C krb5 library, not PyPI krb5
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cccolutils";
  version = "1.5";
  format = "setuptools";

  src = fetchPypi {
    pname = "CCColUtils";
    inherit version;
    hash = "sha256-YzKjG43biRbTZKtzSUHHhtzOfcZfzISHDFolqzrBjL8=";
  };

  buildInputs = [ krb5-c ];

  propagatedBuildInputs = [
    git
    gitpython
    mock
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cccolutils" ];

  meta = {
    description = "Python Kerberos 5 Credential Cache Collection Utilities";
    homepage = "https://pagure.io/cccolutils";
    license = lib.licenses.gpl2Plus;
  };
}
