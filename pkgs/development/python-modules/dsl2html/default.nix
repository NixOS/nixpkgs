{
  lib,
  buildPythonPackage,
  fetchPypi,

  setuptools,
}:

buildPythonPackage rec {
  pname = "dsl2html";
  version = "0.1.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LUtTMqQuwahIeMm9QvMe6rdHEw5LEjMQdyZFZvf/HRU=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "dsl" ];

  meta = with lib; {
    description = "Python module for converting DSL dictionary texts into HTML";
    homepage = "https://github.com/Crissium/python-dsl";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ vizid ];
  };
}
