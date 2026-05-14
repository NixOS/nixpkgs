{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  regex,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rebulk";
  version = "3.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DTC/gPygD6nGlxhaxHXarJveX2Rs4zOMn/XV3B69/rw=";
  };

  build-system = [ setuptools ];

  dependencies = [ regex ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "rebulk" ];

  meta = {
    description = "Advanced string matching from simple patterns";
    homepage = "https://github.com/Toilal/rebulk/";
    changelog = "https://github.com/Toilal/rebulk/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
