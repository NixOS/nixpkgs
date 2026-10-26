{
  lib,
  asttokens,
  buildPythonPackage,
  executing,
  fetchFromGitHub,
  pygments,
  pytest-mock,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "devtools";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = "python-devtools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uy8DIP0szpo1gCm88GR32QOHZqtIQSpuxK63UNMFsn8=";
  };

  pythonRelaxDeps = [ "asttokens" ];

  build-system = [ uv-build ];

  dependencies = [
    asttokens
    executing
    pygments
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  disabledTests = [
    # Test for Windows32
    "test_print_subprocess"
    # Sensitive to timing
    "test_multiple_not_verbose"
    # Sensitive to interpreter output
    "test_simple"
    "test_expr_render"
  ];

  pythonImportsCheck = [ "devtools" ];

  meta = {
    description = "Python's missing debug print command and other development tools";
    homepage = "https://python-devtools.helpmanual.io/";
    changelog = "https://github.com/samuelcolvin/python-devtools/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jdahm ];
  };
})
