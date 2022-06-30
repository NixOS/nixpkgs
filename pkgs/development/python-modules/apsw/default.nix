{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, sqlite
, isPyPy
, python
}:

buildPythonPackage rec {
  pname = "apsw";
  version = "3.38.1-r1";
  format = "setuptools";

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "rogerbinns";
    repo = "apsw";
    rev = version;
    hash = "sha256-pbb6wCu1T1mPlgoydB1Y1AKv+kToGkdVUjiom2vTqf4=";
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
