{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  wheel,
  jaraco-test,
  pytestCheckHook,
}:

let
  self = buildPythonPackage rec {
    pname = "backports-tarfile";
    version = "1.2.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "jaraco";
      repo = "backports.tarfile";
      rev = "v${version}";
      hash = "sha256-X3rkL35aDG+DnIOq0fI7CFoWGNtgLkLjtT9y6+23oto=";
    };

    build-system = [
      setuptools
      setuptools-scm
      wheel
    ];

    doCheck = false;

    nativeCheckInputs = [
      jaraco-test
      pytestCheckHook
    ];

    disabledTests = [
      # calls python -m backports.tarfile and doesn't find module documentation
      "test_bad_use"
      "test_create_command"
      "test_create_command_compressed"
      "test_create_command_dot_started_filename"
      "test_create_command_dotless_filename"
      "test_extract_command"
      "test_extract_command_different_directory"
      "test_extract_command_invalid_file"
      "test_list_command_invalid_file"
      "test_test_command"
      "test_test_command_invalid_file"
      # chmod: permission denied
      "test_modes"
    ];

    pythonImportsCheck = [ "backports.tarfile" ];

    passthru.tests.pytest = self.overridePythonAttrs { doCheck = true; };

    meta = with lib; {
      description = "Backport of CPython tarfile module";
      homepage = "https://github.com/jaraco/backports.tarfile";
      license = licenses.mit;
      maintainers = [ ];
    };
  };
in
self
