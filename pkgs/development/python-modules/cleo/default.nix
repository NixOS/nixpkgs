{ lib
, buildPythonPackage
, clikit
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pytest-mock
}:

buildPythonPackage rec {
  pname = "cleo";
  version = "1.0.0a4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sdispater";
    repo = pname;
    rev = version;
    hash = "sha256-w4WzGK7Q055iPF5wkpVXHoHvwr8ewKDqDUPCdoGhAQ0=";
  };

  propagatedBuildInputs = [ clikit poetry-core ];

  doCheck = true;

  checkInputs = [ pytestCheckHook pytest-mock ];

  pythonImportsCheck = [ "cleo" ];

  meta = with lib; {
    homepage = "https://github.com/sdispater/cleo";
    description = "Allows you to create beautiful and testable command-line interfaces";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
