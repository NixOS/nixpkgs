{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  tokenize-rt,
}:

buildPythonPackage rec {
  pname = "pyupgrade";
  version = "3.21.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "pyupgrade";
    rev = "v${version}";
    hash = "sha256-u4iudzPhVuAOS9cL3z6FCVpWKJZHg7UGpe9aHnN7Byc=";
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
}
