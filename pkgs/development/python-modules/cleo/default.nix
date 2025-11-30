{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  crashtest,
  poetry-core,
  pytest-mock,
  pytestCheckHook,
  rapidfuzz,
}:

buildPythonPackage rec {
  pname = "cleo";
  version = "2.2.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = "cleo";
    tag = version;
    hash = "sha256-+OvE09hbF6McdXpXdv5UBdZ0LiSOTL8xyE/+bBNIFNk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonRelaxDeps = [ "rapidfuzz" ];

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
