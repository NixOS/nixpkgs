{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  testfixtures,
}:

buildPythonPackage rec {
  pname = "bump2version";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "c4urself";
    repo = "bump2version";
    tag = "v${version}";
    sha256 = "sha256-j6HKi3jTwSgGBrA8PCJJNg+yQqRMo1aqaLgPGf4KAKU=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    testfixtures
  ];

  disabledTests = [
    # X's in pytest are git tests which won't run in sandbox
    "usage_string_fork"
    "test_usage_string"
    "test_defaults_in_usage_with_config"
  ];

  pythonImportsCheck = [ "bumpversion" ];

  meta = {
    description = "Version-bump your software with a single command";
    longDescription = ''
      A small command line tool to simplify releasing software by updating
      all version strings in your source code by the correct increment.
    '';
    homepage = "https://github.com/c4urself/bump2version";
    changelog = "https://github.com/c4urself/bump2version/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jefflabonte ];
  };
}
