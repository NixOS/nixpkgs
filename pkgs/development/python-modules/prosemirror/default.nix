{
  lib,
  buildPythonPackage,
  hatchling,
  hatch-vcs,
  pytestCheckHook,
  fetchPypi,
  lxml,
  cssselect,
}:

buildPythonPackage rec {
  pname = "prosemirror";
  version = "0.6.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7sRaTzXQPdtYcAGZKSZGw0szS7rThaIWefx6jRgc0nI=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    lxml
    cssselect
  ];

  pythonImportsCheck = [ "prosemirror" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python implementation of core ProseMirror modules for collaborative editing";
    homepage = "https://pypi.org/project/prosemirror";
    changelog = "https://github.com/fellowapp/prosemirror-py/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ onny ];
  };
}
