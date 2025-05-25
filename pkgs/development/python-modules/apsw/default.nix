{
  stdenv,
  lib,
  buildPythonPackage,
  fetchurl,
  pytestCheckHook,
  setuptools,
  sqlite,
}:

buildPythonPackage rec {
  pname = "apsw";
  version = "3.48.0.0";
  pyproject = true;

  # https://github.com/rogerbinns/apsw/issues/548
  src = fetchurl {
    url = "https://github.com/rogerbinns/apsw/releases/download/${version}/apsw-${version}.tar.gz";
    hash = "sha256-iwvUW6vOQu2EiUuYWVaz5D3ePSLrj81fmLxoGRaTzRk=";
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

  meta = {
    changelog = "https://github.com/rogerbinns/apsw/blob/${version}/doc/changes.rst";
    description = "Python wrapper for the SQLite embedded relational database engine";
    homepage = "https://github.com/rogerbinns/apsw";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ gador ];
  };
}
