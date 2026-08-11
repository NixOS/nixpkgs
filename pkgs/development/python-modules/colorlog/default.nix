{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "colorlog";
  version = "6.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "borntyping";
    repo = "python-colorlog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iRtS2g23gu7LAhOfmRhPISf90lVwC2O+oTiTGaeZlas=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "colorlog" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/borntyping/python-colorlog/releases/tag/${finalAttrs.src.tag}";
    description = "Log formatting with colors";
    homepage = "https://github.com/borntyping/python-colorlog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
