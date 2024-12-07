{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  pycryptodomex,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyzipper";
  version = "0.3.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "danifus";
    repo = "pyzipper";
    rev = "refs/tags/v${version}";
    hash = "sha256-+fZXoAUeB/bUI3LrIFlMTktJgn+GNFBiDHvH2Jgo0pg=";
  };

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ pycryptodomex ];

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

  meta = with lib; {
    description = "Python zipfile extensions";
    homepage = "https://github.com/danifus/pyzipper";
    changelog = "https://github.com/danifus/pyzipper/blob/v${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
