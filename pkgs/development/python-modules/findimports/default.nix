{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "findimports";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mgedmin";
    repo = "findimports";
    tag = finalAttrs.version;
    hash = "sha256-3MYHl35FfStmyhBNvedIHIZQYTyBuRyg5OI3d3Mi57I=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "findimports" ];

  meta = {
    description = "Module for the analysis of Python import statements";
    homepage = "https://github.com/mgedmin/findimports";
    changelog = "https://github.com/mgedmin/findimports/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "findimports";
  };
})
