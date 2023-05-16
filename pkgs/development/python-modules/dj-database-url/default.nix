{ lib
, buildPythonPackage
, fetchPypi
, django
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dj-database-url";
<<<<<<< HEAD
  version = "2.1.0";
=======
  version = "2.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-8gQs7+EIblOcnaOfrVrX9hFzv3lmXmm/fk3lX6iLE18=";
=======
    hash = "sha256-o1qfD0N3XKb5DYGdxFYjPve8x2tHN31dkIt1x+syBiQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    django
  ];

  # Tests access a DB via network
  doCheck = false;

  pythonImportsCheck = [
    "dj_database_url"
  ];

  meta = with lib; {
    description = "Use Database URLs in your Django Application";
    homepage = "https://github.com/jazzband/dj-database-url";
    changelog = "https://github.com/jazzband/dj-database-url/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
