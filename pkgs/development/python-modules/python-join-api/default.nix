{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  flask,
  requests,
}:

buildPythonPackage rec {
  pname = "python-join-api";
  version = "0.0.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FGqOqOd9VVH9hxMqYH7M10W+g5tpImxs+K4AHJJZRaE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flask
    requests
  ];

  pythonImportsCheck = [ "pyjoin" ];

  # No tests
  doCheck = false;

  meta = {
    description = "Python API for interacting with Join by joaoapps";
    homepage = "https://github.com/nkgilley/python-join-api";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
