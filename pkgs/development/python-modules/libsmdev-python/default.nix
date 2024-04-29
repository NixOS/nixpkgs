{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "libsmdev-python";
  version = "20240309";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ERRXEggcxoRob3nnC9hQ9JMOfuvc9CXIOKFlrblcg9g=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pysmdev" ];

  meta = with lib; {
    changelog = "https://github.com/libyal/libsmdev/releases/tag/${version}";
    description = "Python bindings module for libsmdev";
    downloadPage = "https://github.com/libyal/libsmdev/releases";
    homepage = "https://github.com/libyal/libsmdev";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
