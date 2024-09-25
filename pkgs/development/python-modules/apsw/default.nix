{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
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
    rev = "refs/tags/${version}";
    hash = "sha256-/MMCwdd2juFbv/lrYwuO2mdWm0+v+YFn6h9CwdQMTpg=";
  };

  build-system = [ setuptools ];

  buildInputs = [ sqlite ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "apsw/tests.py" ];

  disabledTests = [
    # we don't build the test extension
    "testLoadExtension"
    "testShell"
    "testVFS"
    "testVFSWithWAL"
    # no lines in errout.txt
    "testWriteUnraisable"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ "testzzForkChecker" ];

  pythonImportsCheck = [ "apsw" ];

  meta = with lib; {
    changelog = "https://github.com/rogerbinns/apsw/blob/${src.rev}/doc/changes.rst";
    description = "Python wrapper for the SQLite embedded relational database engine";
    homepage = "https://github.com/rogerbinns/apsw";
    license = licenses.zlib;
    maintainers = with maintainers; [ gador ];
  };
}
