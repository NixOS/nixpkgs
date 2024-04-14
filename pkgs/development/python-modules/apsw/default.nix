{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  pythonOlder,
  setuptools,
  sqlite,
}:

buildPythonPackage rec {
  pname = "apsw";
  version = "3.45.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rogerbinns";
    repo = "apsw";
    rev = "refs/tags/${version}";
    hash = "sha256-tTi3/10W4OoGH6PQVhvPWc5o09on5BZrWoAvrfh4C/E=";
  };

  build-system = [ setuptools ];

  buildInputs = [ sqlite ];

  # Project uses custom test setup to exclude some tests by default, so using pytest
  # requires more maintenance
  # https://github.com/rogerbinns/apsw/issues/335
  checkPhase = ''
    ${python.interpreter} setup.py test
  '';

  pythonImportsCheck = [ "apsw" ];

  meta = with lib; {
    description = "A Python wrapper for the SQLite embedded relational database engine";
    homepage = "https://github.com/rogerbinns/apsw";
    changelog = "https://github.com/rogerbinns/apsw/releases/tag/${version}";
    license = licenses.zlib;
    maintainers = with maintainers; [ gador ];
  };
}
