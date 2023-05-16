{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, duckdb
, hypothesis
, ipython-sql
, poetry-core
<<<<<<< HEAD
, snapshottest
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, sqlalchemy
, typing-extensions
}:

buildPythonPackage rec {
  pname = "duckdb-engine";
<<<<<<< HEAD
  version = "0.7.3";
=======
  version = "0.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    repo = "duckdb_engine";
    owner = "Mause";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-Z9m1+Bc/csWKdPDuwf82xX0qOiD1Y5LBgJjUlLntAO8=";
=======
    hash = "sha256-qLQjFkud9DivLQ9PignLrXlUVOAxsd28s7+2GdC5jKE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    duckdb
    sqlalchemy
  ];

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

<<<<<<< HEAD
  disabledTests = [
    # this test tries to download the httpfs extension
    "test_preload_extension"
    # test should be skipped based on sqlalchemy version but isn't and fails
    "test_commit"
=======
  # this test tries to download the httpfs extension
  disabledTests = [
    "test_preload_extension"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    ipython-sql
<<<<<<< HEAD
    # TODO(cpcloud): include pandas here when it supports sqlalchemy 2.0
    snapshottest
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    typing-extensions
  ];

  pythonImportsCheck = [
    "duckdb_engine"
  ];

  meta = with lib; {
    description = "SQLAlchemy driver for duckdb";
    homepage = "https://github.com/Mause/duckdb_engine";
    changelog = "https://github.com/Mause/duckdb_engine/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
