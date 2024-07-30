{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "flupy";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ekh6AI6XRM010PbqPPoG9LKyfLE4v1fQeI9cJuV6/mk=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  pythonImportsCheck = [ "flupy" ];

  meta = with lib; {
    description = "Fluent data pipelines for python and your shell";
    homepage = "https://github.com/olirice/flupy";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.viraptor ];
  };
}
