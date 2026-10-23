{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  toml,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pure-eval";
  version = "0.2.4";
  format = "setuptools";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = "pure_eval";
    rev = "v${finalAttrs.version}";
    hash = "sha256-F2IalcLbIXBSTd0YE7jIJFwXr5ViPQd16FyzrPLD04o=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ toml ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pure_eval" ];

  meta = {
    description = "Safely evaluate AST nodes without side effects";
    homepage = "https://github.com/alexmojaki/pure_eval";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
