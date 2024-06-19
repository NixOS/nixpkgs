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
  version = "4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "praiskup";
    repo = "argparse-manpage";
    rev = "v${version}";
    hash = "sha256-9lriW+Yx/6ysoumloQglDm5JEcKNUWm422B3P6IE/EE=";
  };

  nativeBuildInputs = [
    setuptools
    packaging
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

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

  pythonImportsCheck = [ "argparse_manpage" ];

  passthru.optional-dependencies = {
    setuptools = [ setuptools ];
  };

  meta = with lib; {
    description = "Automatically build man-pages for your Python project";
    homepage = "https://github.com/praiskup/argparse-manpage";
    changelog = "https://github.com/praiskup/argparse-manpage/blob/${src.rev}/NEWS";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "argparse-manpage";
  };
}
