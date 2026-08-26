{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  packaging,
  pytestCheckHook,
  pip,
}:

buildPythonPackage rec {
  pname = "argparse-manpage";
  version = "4.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "praiskup";
    repo = "argparse-manpage";
    tag = "v${version}";
    hash = "sha256-nonC0oK3T/8+gSa0lRaCf2wvvXoRBPP8b1jioNmW4qI=";
  };

  nativeBuildInputs = [
    setuptools
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pip
  ];

  disabledTests = [
    # TypeError: dist must be a Distribution instance
    "test_old_example"
    "test_old_example_file_name"
  ];

  disabledTestPaths = [
    # network access to install setuptools, likely due to pip update
    "tests/test_examples.py"
  ];

  pythonImportsCheck = [ "argparse_manpage" ];

  optional-dependencies = {
    setuptools = [ setuptools ];
  };

  meta = {
    description = "Automatically build man-pages for your Python project";
    homepage = "https://github.com/praiskup/argparse-manpage";
    changelog = "https://github.com/praiskup/argparse-manpage/blob/${src.tag}/NEWS";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nickcao ];
    mainProgram = "argparse-manpage";
  };
}
