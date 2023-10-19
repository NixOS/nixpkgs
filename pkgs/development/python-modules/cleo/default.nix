{ lib
, buildPythonPackage
, fetchFromGitHub
, crashtest
, poetry-core
, pytest-mock
, pytestCheckHook
, pythonRelaxDepsHook
, rapidfuzz
}:

buildPythonPackage rec {
  pname = "cleo";
  version = "2.0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-y9PYlGSPLpZl9Ad2AFuDKIopH0LRETLp35aiZtLcXzM=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "rapidfuzz"
  ];

  propagatedBuildInputs = [
    crashtest
    rapidfuzz
  ];

  pythonImportsCheck = [
    "cleo"
    "cleo.application"
    "cleo.commands.command"
    "cleo.helpers"
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/python-poetry/cleo";
    changelog = "https://github.com/python-poetry/cleo/blob/${src.rev}/CHANGELOG.md";
    description = "Allows you to create beautiful and testable command-line interfaces";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
