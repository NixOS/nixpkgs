{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, poetry
, typer
, setuptools
}:

buildPythonPackage rec {
  version = "0.2.1";
  pname = "pipenv-poetry-migrate";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "yhino";
    repo = "pipenv-poetry-migrate";
    rev = "refs/tags/v${version}";
    hash = "sha256-aP8bzWFUzAZrEsz8pYL2y5c7GaUjWG5GA+cc4/tGPZk=";
  };

    nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    poetry
    typer
  ];

  postPatch = ''
  substituteInPlace pyproject.toml --replace 'typer = "^0.4.0"' 'typer = ">=0.4"'
  '';

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "This is simple migration script, migrate pipenv to poetry";
    homepage = "https://github.com/yhino/pipenv-poetry-migrate";
    license = licenses.asl20;
    maintainers = with maintainers; [ gador ];
  };
}
