{
  lib,
  buildPythonPackage,
  fetchPypi,

  setuptools,
}:

buildPythonPackage rec {
  pname = "dsl2html";
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GIJgkUbnU3eRkBgkguAINgMH1YnDSs5I9gIdQWvmVc0=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "dsl" ];

  meta = {
    description = "Python module for converting DSL dictionary texts into HTML";
    homepage = "https://github.com/Crissium/python-dsl";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ vizid ];
  };
}
