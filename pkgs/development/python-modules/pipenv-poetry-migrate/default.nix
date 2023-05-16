{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, poetry-core
, tomlkit
, typer
, setuptools
}:

buildPythonPackage rec {
  pname = "pipenv-poetry-migrate";
<<<<<<< HEAD
  version = "0.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "0.3.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "yhino";
    repo = "pipenv-poetry-migrate";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-z5pBkB5J8FnuebMW4bPpk0cT2nd5bH/4PBR12g0lEQw=";
=======
    hash = "sha256-aPG0MgChnJbivJRjYx9aQE5OPhL4WlPyt5uKCHZUpeE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    setuptools # for pkg_resources
    tomlkit
    typer
  ];

<<<<<<< HEAD
=======
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'typer = "^0.4.0"' 'typer = ">=0.4"'
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "This is simple migration script, migrate pipenv to poetry";
    homepage = "https://github.com/yhino/pipenv-poetry-migrate";
    changelog = "https://github.com/yhino/pipenv-poetry-migrate/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ gador ];
  };
}
