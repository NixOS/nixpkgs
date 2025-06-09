{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  sqlite,
}:

buildPythonPackage rec {
  pname = "apsw";
  version = "3.46.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rogerbinns";
    repo = "apsw";
    tag = version;
    hash = "sha256-/MMCwdd2juFbv/lrYwuO2mdWm0+v+YFn6h9CwdQMTpg=";
  };

  build-system = [ setuptools ];

  buildInputs = [ sqlite ];

  # apsw explicitly doesn't use pytest
  # see https://github.com/rogerbinns/apsw/issues/548#issuecomment-2891633403
  checkPhase = ''
    runHook preCheck
    python -m apsw.tests
    runHook postCheck
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
