{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  pycryptodomex,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyzipper";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "danifus";
    repo = "pyzipper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-an+DmsyoIAwYvYXGFnJ/3+KIf6sqNJlA7uJp0leV18I=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ setuptools ];

  dependencies = [ pycryptodomex ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyzipper" ];

  doCheck = pythonOlder "3.13"; # depends on removed nntplib battery

  disabledTests = [
    # Tests are parsing CLI output
    "test_args_from_interpreter_flags"
    "test_bad_use"
    "test_bad_use"
    "test_check__all__"
    "test_create_command"
    "test_extract_command"
    "test_main"
    "test_temp_dir__forked_child"
    "test_test_command"
    # Test wants to import asyncore
    "test_CleanImport"
  ];

  meta = {
    description = "Python zipfile extensions";
    homepage = "https://github.com/danifus/pyzipper";
    changelog = "https://github.com/danifus/pyzipper/blob/v${finalAttrs.src.tag}/HISTORY.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
