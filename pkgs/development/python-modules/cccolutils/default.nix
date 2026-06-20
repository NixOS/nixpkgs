{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  git,
  gitpython,
  krb5-c, # C krb5 library, not PyPI krb5
  mock,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cccolutils";
  version = "1.5";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "CCColUtils";
    inherit (finalAttrs) version;
    hash = "sha256-YzKjG43biRbTZKtzSUHHhtzOfcZfzISHDFolqzrBjL8=";
  };

  build-system = [ setuptools ];

  buildInputs = [ krb5-c ];

  dependencies = [
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
})
