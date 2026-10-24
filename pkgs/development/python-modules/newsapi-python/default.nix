{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
}:

buildPythonPackage rec {
  pname = "newsapi-python";
  version = "0.2.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pLZtXdmJIZjNqkdvdULyYlzdIY5eMSHI+ICyrOcXo8I=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Tests require API keys
  doCheck = false;

  pythonImportsCheck = [ "newsapi" ];

  meta = {
    description = "Python client for the News API";
    homepage = "https://github.com/mattlisiv/newsapi-python";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
