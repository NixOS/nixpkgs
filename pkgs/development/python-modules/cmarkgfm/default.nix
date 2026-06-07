{
  lib,
  buildPythonPackage,
  cffi,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cmarkgfm";
  version = "2025.10.22";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-W+xhAHtluRlIhELIOMWKbIv0dB9RA8WTsu8YDTmBjto=";
  };

  build-system = [ setuptools ];

  propagatedNativeBuildInputs = [ cffi ];

  dependencies = [ cffi ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cmarkgfm" ];

  meta = {
    description = "Minimal bindings to GitHub's fork of cmark";
    homepage = "https://github.com/jonparrott/cmarkgfm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
