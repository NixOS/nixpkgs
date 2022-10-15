{ lib
, buildPythonPackage
, fetchFromGitHub
, crashtest
, poetry-core
, pylev
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cleo";
  version = "1.0.0a5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-FtGGIRF/tA2OWEjkCFwa1HHg6VY+5E5mAiJC/zjUC1g=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'crashtest = "^0.3.1"' 'crashtest = "*"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    crashtest
    pylev
  ];

  pythonImportsCheck = [
    "cleo"
    "cleo.application"
    "cleo.commands.command"
    "cleo.helpers"
  ];

  checkInputs = [
    pytest-mock
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/python-poetry/cleo";
    description = "Allows you to create beautiful and testable command-line interfaces";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
