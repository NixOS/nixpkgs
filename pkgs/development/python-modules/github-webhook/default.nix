{
  lib,
  buildPythonPackage,
  fetchPypi,
  flask,
  six,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "github-webhook";
  version = "1.0.4";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-skRNv9A97aNXkr0A69FpJZfCYFxhRF2nnaYyKvrKeo0=";
  };

  build-system = [ setuptools ];
  dependencies = [
    flask
    six
  ];

  # touches network
  doCheck = false;

  meta = {
    description = "Framework for writing webhooks for GitHub";
    homepage = "https://github.com/bloomberg/python-github-webhook";
    license = lib.licenses.mit;
  };
})
