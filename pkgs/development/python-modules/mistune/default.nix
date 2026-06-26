{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mistune";
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "mistune";
    tag = "v${version}";
    hash = "sha256-8AEEh/SWAk/Esq0jAoZGLw1FIQUw6C5Xq8CgnI2fjv0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mistune" ];

  meta = {
    changelog = "https://github.com/lepture/mistune/blob/${src.tag}/docs/changes.rst";
    description = "Sane Markdown parser with useful plugins and renderers";
    homepage = "https://github.com/lepture/mistune";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
