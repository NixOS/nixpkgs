{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  # build system
  setuptools,

  # test dependencies
  pytestCheckHook,
}:
let
  pname = "lazy-imports";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "bachorp";
    repo = "lazy-imports";
    tag = version;
    hash = "sha256-KtKqR/e0ldpsrz3dyY1ehF4cM5k7jDziiB+8uV0HEwc=";
  };
in
buildPythonPackage {
  inherit pname version src;
  pyproject = true;

  build-system = [ setuptools ];

  pythonImportsCheck = [ "lazy_imports" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Utility package to create lazy modules, deferring associated imports until attribute access";
    homepage = "https://github.com/bachorp/lazy-imports";
    changelog = "https://github.com/bachorp/lazy-imports/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
