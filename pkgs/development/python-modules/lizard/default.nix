{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  mock,
  jinja2,
  pygments, # for Erlang support
  pathspec, # for .gitignore support
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "lizard";
  version = "1.24.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "terryyin";
    repo = "lizard";
    tag = finalAttrs.version;
    hash = "sha256-npxnl9QrsAMLgrSDGsmWTb17VLwJ9sYCi9dhROCblhg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jinja2
    pygments
    pathspec
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  disabledTestPaths = [
    # re.error: global flags not at the start of the expression at position 14
    "test/test_languages/testFortran.py"
  ];

  pythonImportsCheck = [ "lizard" ];

  meta = {
    changelog = "https://github.com/terryyin/lizard/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Code analyzer without caring the C/C++ header files";
    mainProgram = "lizard";
    downloadPage = "https://github.com/terryyin/lizard";
    homepage = "http://www.lizard.ws";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jpetrucciani ];
  };
})
