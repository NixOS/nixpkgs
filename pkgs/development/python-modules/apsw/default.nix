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
  version = "3.39.3.0";
  format = "setuptools";

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "rogerbinns";
    repo = "apsw";
    rev = "refs/tags/${version}";
    hash = "sha256-rUG6TXGdF+XaRTFn2luffYw+1EEChxtLgQx2Gn+7J6A=";
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
