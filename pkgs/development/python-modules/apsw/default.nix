{ lib
, buildPythonPackage
, fetchFromGitHub
, sqlite
, isPyPy
, python
}:

buildPythonPackage rec {
  pname = "apsw";
<<<<<<< HEAD
  version = "3.42.0.0";
=======
  version = "3.41.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "rogerbinns";
    repo = "apsw";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-pLkYTyf2BGRLs4bChb+eo2i5gRRUUJDFyfCBTSJ1RkQ=";
=======
    hash = "sha256-U7NhC83wBaUONLsQbL+j9866u4zs58O6AQxwzS3e0qM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [
    sqlite
  ];

  # Project uses custom test setup to exclude some tests by default, so using pytest
  # requires more maintenance
  # https://github.com/rogerbinns/apsw/issues/335
  checkPhase = ''
    ${python.interpreter} setup.py test
  '';

  pythonImportsCheck = [
    "apsw"
  ];

  meta = with lib; {
    description = "A Python wrapper for the SQLite embedded relational database engine";
    homepage = "https://github.com/rogerbinns/apsw";
    license = licenses.zlib;
    maintainers = with maintainers; [ gador ];
  };
}
