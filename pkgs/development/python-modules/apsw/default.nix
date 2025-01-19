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
  version = "3.48.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rogerbinns";
    repo = "apsw";
    tag = version;
    hash = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";
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
    changelog = "https://github.com/rogerbinns/apsw/blob/${src.tag}/doc/changes.rst";
    description = "Python wrapper for the SQLite embedded relational database engine";
    homepage = "https://github.com/rogerbinns/apsw";
    license = licenses.zlib;
    maintainers = with maintainers; [ gador ];
  };
}
