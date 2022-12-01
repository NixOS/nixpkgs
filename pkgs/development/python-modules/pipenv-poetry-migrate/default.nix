{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
, pythonOlder
, poetry-core
, tomlkit
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

  patches = [
    (fetchpatch {
      name = "use-poetry-core.patch";
      url = "https://github.com/yhino/pipenv-poetry-migrate/commit/726ebd823bf6ef982992085bd04e41d178775b98.patch";
      hash = "sha256-TBVH1MZA0O1/2zLpVgNckLaP4JO3wIJJi0Nst726erk=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    setuptools # for pkg_resources
    tomlkit
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
