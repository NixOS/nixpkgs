{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build-system
, poetry-core

# runtime
, click
, peewee

# tests
, psycopg2
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "peewee-migrate";
<<<<<<< HEAD
  version = "1.10.1";
=======
  version = "1.7.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "klen";
    repo = "peewee_migrate";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-SBHeXHfhYjyXr+tODryKQfxZKy7l4ez5C6eU6FjS2qI=";
=======
    hash = "sha256-s7/Ev4nAKUr5OBgziETVCtjlxvBoeoZXriUBuAUi4eE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  postPatch = ''
    sed -i '/addopts/d' pyproject.toml
  '';

  propagatedBuildInputs = [
    peewee
    click
  ];

  pythonImportsCheck = [
    "peewee_migrate"
  ];

  nativeCheckInputs = [
    psycopg2
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Simple migration engine for Peewee";
    homepage = "https://github.com/klen/peewee_migrate";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
