{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flask,
  requests,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-join-api";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nkgilley";
    repo = "python-join-api";
    tag = finalAttrs.version;
    hash = "sha256-sT/IS7UshXSVaonegvcn4u2a8CNCRiiovcQ8uAyfU1Q=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flask
    requests
    yarl
  ];

  pythonImportsCheck = [ "pyjoin" ];

  # No tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/nkgilley/python-join-api/releases/tag/${finalAttrs.src.tag}";
    description = "Python API for interacting with Join by joaoapps";
    homepage = "https://github.com/nkgilley/python-join-api";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
