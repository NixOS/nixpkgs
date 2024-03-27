{ buildPythonPackage
, cookiecutter
, fetchFromGitHub
, gitpython
, lib
, poetry-core
, pytestCheckHook
, pytest_7
, typer
}:
buildPythonPackage rec {
  pname = "cruft";
  version = "2.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cruft";
    repo = "cruft";
    rev = version;
    hash = "sha256-qIVyNMoI3LsoOV/6XPa60Y1vTRvkezesF7wF9WVSLGk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    (pytestCheckHook.override { pytest = pytest_7; })
  ];

  propagatedBuildInputs = [
    cookiecutter
    gitpython
    typer
  ];

  # Unfortunately, some tests require internet access to fully clone
  # https://github.com/cruft/cookiecutter-test (including all branches)
  # which is possible to package, but is annoying and may be not always pure
  #
  # See https://discourse.nixos.org/t/keep-git-folder-in-when-fetching-a-git-repo/8590/6
  #
  # There are only 13 tests which do not require internet access on moment of the writing.
  # But some tests are better than none, right?
  disabledTests = [
    "test_get_diff_with_add"
    "test_get_diff_with_delete"
    "test_get_diff_with_unicode"
  ];

  disabledTestPaths = [
    "tests/test_api.py" # only 2 tests pass, and 24 fail. I am going to ignore entire file
    "tests/test_cli.py"
  ];

  meta = {
    changelog = "https://github.com/cruft/cruft/blob/${version}/CHANGELOG.md";
    description = "cruft allows you to maintain all the necessary boilerplate for building projects";
    homepage = "https://github.com/cruft/cruft";
    license = lib.licenses.mit;
    mainProgram = "cruft";
    maintainers = with lib.maintainers; [ perchun ];
  };
}
