{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, poetry
, rich
, setuptools
}:

buildPythonPackage rec {
  version = "0.2.0";
  pname = "pipenv-poetry-migrate";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "yhino";
    repo = "pipenv-poetry-migrate";
    rev = "v${version}";
    hash = "sha256-2/e6uGwpUvzxXlz+51gUriE054bgNeJNyLDCIyiGflM=";
  };

  propagatedBuildInputs = [
    poetry
    rich
    setuptools
  ];

  postPatch = ''
  substituteInPlace pyproject.toml --replace 'rich = "^9.6.1"' 'rich = ">9"'
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
