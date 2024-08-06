{
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
  ];

  pythonImportsCheck = [ "apsw" ];

  meta = with lib; {
    changelog = "https://github.com/rogerbinns/apsw/blob/${src.rev}/doc/changes.rst";
    description = "Python wrapper for the SQLite embedded relational database engine";
    homepage = "https://github.com/rogerbinns/apsw";
    license = licenses.zlib;
    maintainers = with maintainers; [ gador ];
  };
}
