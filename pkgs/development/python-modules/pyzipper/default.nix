{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, pycryptodomex
}:

buildPythonPackage rec {
  pname = "pyzipper";
  version = "0.3.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "danifus";
    repo = "pyzipper";
    rev = "refs/tags/v${version}";
    hash = "sha256-+fZXoAUeB/bUI3LrIFlMTktJgn+GNFBiDHvH2Jgo0pg=";
  };

  propagatedBuildInputs = [
    pycryptodomex
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyzipper"
  ];

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
  ];

  meta = with lib; {
    description = "Python zipfile extensions";
    homepage = "https://github.com/danifus/pyzipper";
    changelog = "https://github.com/danifus/pyzipper/blob/v${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
