{
  lib,
  buildPythonPackage,
  setuptools-scm,
  pytestCheckHook,
  fetchPypi,
  lxml,
  cssselect,
}:

buildPythonPackage rec {
  pname = "prosemirror";
  version = "0.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-COjCU//frJf2MNgaAz5aQizbjRsF3ypYFXS6aDjqrIU=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    lxml
    cssselect
  ];

  pythonImportsCheck = [ "prosemirror" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python implementation of core ProseMirror modules for collaborative editing";
    homepage = "https://pypi.org/project/prosemirror";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ onny ];
  };
}
