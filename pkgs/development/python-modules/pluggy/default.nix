{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  setuptools-scm,
  callPackage,
}:

buildPythonPackage (finalAttrs: {
  pname = "pluggy";
  version = "1.6.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pluggy";
    tag = finalAttrs.version;
    hash = "sha256-pkQjPJuSASWmzwzp9H/UTJBQDr2r2RiofxpF135lAgc=";
  };

  build-system = [ setuptools-scm ];

  # To prevent infinite recursion with pytest
  doCheck = false;
  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  __structuredAttrs = true;

  meta = {
    changelog = "https://github.com/pytest-dev/pluggy/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    description = "Plugin and hook calling mechanisms for Python";
    homepage = "https://github.com/pytest-dev/pluggy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
