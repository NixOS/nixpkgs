{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  setuptools-scm,
  callPackage,
}:

buildPythonPackage (finalAttrs: {
  pname = "pluggy";
  version = "1.7.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pluggy";
    tag = finalAttrs.version;
    hash = "sha256-wQr2dFG8gh58v9CbmNhLX3Znuj+JeBAm3SHXJXMztXA=";
  };

  build-system = [ setuptools-scm ];

  # To prevent infinite recursion with pytest
  doCheck = false;
  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = {
    changelog = "https://github.com/pytest-dev/pluggy/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    description = "Plugin and hook calling mechanisms for Python";
    homepage = "https://github.com/pytest-dev/pluggy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
