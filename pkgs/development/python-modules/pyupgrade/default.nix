{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  tokenize-rt,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyupgrade";
  version = "3.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "pyupgrade";
    rev = "v${finalAttrs.version}";
    hash = "sha256-B3x1ykS+8gzaDIYb1f6locaHw/wBMdGfniEbthDdrL4=";
  };

  build-system = [ setuptools ];

  dependencies = [ tokenize-rt ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyupgrade" ];

  meta = {
    description = "Tool to automatically upgrade syntax for newer versions of the language";
    mainProgram = "pyupgrade";
    homepage = "https://github.com/asottile/pyupgrade";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lovesegfault ];
  };
})
