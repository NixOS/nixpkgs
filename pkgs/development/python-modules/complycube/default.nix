{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyhumps,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "complycube";
  version = "1.1.8";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "complycube";
    hash = "sha256-lN8J9QQ9YvclYzuXtck+lt1IgS5McOE1YU0NLl9rW0I=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    pyhumps
    requests
  ];

  pythonImportsCheck = [ "complycube" ];

  meta = {
    homepage = "https://complycube.com";
    description = "Official Python client for the ComplyCube API";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
