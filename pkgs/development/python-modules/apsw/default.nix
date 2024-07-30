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
  version = "3.46.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rogerbinns";
    repo = "apsw";
    rev = "refs/tags/${version}";
    hash = "sha256-GcfHkK4TCHPA2K6ymXtpCwNUCCUq0vq98UjYGGwn588=";
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
    changelog = "https://github.com/rogerbinns/apsw/blob/${src.rev}/doc/changes.rst";
    description = "Python wrapper for the SQLite embedded relational database engine";
    homepage = "https://github.com/rogerbinns/apsw";
    license = licenses.zlib;
    maintainers = with maintainers; [ gador ];
  };
}
