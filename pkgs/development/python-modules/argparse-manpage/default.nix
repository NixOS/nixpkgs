{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  packaging,
  tomli,
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
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.11") [ tomli ];

  nativeCheckInputs = [
    pytestCheckHook
    pip
  ];

  disabledTests = [
    # TypeError: dist must be a Distribution instance
    "test_old_example"
    "test_old_example_file_name"
  ];

<<<<<<< HEAD
  disabledTestPaths = [
    # network access to install setuptools, likely due to pip update
    "tests/test_examples.py"
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pythonImportsCheck = [ "argparse_manpage" ];

  optional-dependencies = {
    setuptools = [ setuptools ];
  };

<<<<<<< HEAD
  meta = {
    description = "Automatically build man-pages for your Python project";
    homepage = "https://github.com/praiskup/argparse-manpage";
    changelog = "https://github.com/praiskup/argparse-manpage/blob/${src.tag}/NEWS";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nickcao ];
=======
  meta = with lib; {
    description = "Automatically build man-pages for your Python project";
    homepage = "https://github.com/praiskup/argparse-manpage";
    changelog = "https://github.com/praiskup/argparse-manpage/blob/${src.tag}/NEWS";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "argparse-manpage";
  };
}
