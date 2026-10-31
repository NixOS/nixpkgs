{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,
  setuptools,
}:

buildPythonPackage rec {
  pname = "leveldb";
  version = "0.201";

  pyproject = true;

  disabled = pythonAtLeast "3.12";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HP/ndoQpF+CfBzvW6lhWxkE2rr3b5RvRfqKZE0cv7L8=";
  };

  nativeBuildInputs = [ setuptools ];

  meta = {
    homepage = "https://code.google.com/archive/p/py-leveldb/";
    description = "Thread-safe Python bindings for LevelDB";
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.aanderse ];
  };
}
