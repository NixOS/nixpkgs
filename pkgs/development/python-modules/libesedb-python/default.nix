{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "libesedb-python";
  version = "20240420";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RyfQpuPRUfShQQfouOP4zO0QuUZmV8xqhWycf4bX0IE=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyesedb" ];

  meta = with lib; {
    changelog = "https://github.com/libyal/libesedb/releases/tag/${version}";
    description = "Python bindings module for libesedb";
    homepage = "https://github.com/libyal/libesedb";
    downloadPage = "https://github.com/libyal/libesedb/releases";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
