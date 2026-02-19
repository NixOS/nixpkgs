{
  lib,
  buildPythonPackage,
  cffi,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cmarkgfm";
  version = "2024.11.20";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XdAc9hl1qKVyE83vXthw6TYDLxP+k9YN32Wf+5z3PGo=";
  };

  propagatedNativeBuildInputs = [ cffi ];

  propagatedBuildInputs = [ cffi ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cmarkgfm" ];

  meta = {
    description = "Minimal bindings to GitHub's fork of cmark";
    homepage = "https://github.com/jonparrott/cmarkgfm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
