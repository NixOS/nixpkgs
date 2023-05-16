{ lib
, stdenv
, buildPythonPackage
, fetchFromSourcehut
, pytestCheckHook
, pythonOlder
, sqlparse
, wrapt
}:

buildPythonPackage rec {
  pname = "embrace";
<<<<<<< HEAD
  version = "4.2.1";
=======
  version = "4.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromSourcehut {
    vc = "hg";
    owner = "~olly";
    repo = "embrace-sql";
    rev = "v${version}-release";
<<<<<<< HEAD
    hash = "sha256-B/xW5EfaQWW603fjKYcf+RHQJVZrnFoqVnIl6xSwS0E=";
=======
    hash = "sha256-otzpDMtC229qMXon+ydS39SBoMiXJmxn48/TQXjqu5U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    sqlparse
    wrapt
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "embrace"
  ];

  # Some test for hot-reload fails on Darwin, but the rest of the library
  # should remain usable. (https://todo.sr.ht/~olly/embrace-sql/4)
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Embrace SQL keeps your SQL queries in SQL files";
    homepage = "https://pypi.org/project/embrace/";
    license = licenses.asl20;
    maintainers = with maintainers; [ pacien ];
  };
}
