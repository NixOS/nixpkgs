{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  setuptools-scm,
  pythonOlder,
  callPackage,
}:

buildPythonPackage rec {
  pname = "pluggy";
  version = "1.6.0";

  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pluggy";
    tag = version;
    hash = "sha256-pkQjPJuSASWmzwzp9H/UTJBQDr2r2RiofxpF135lAgc=";
  };

  build-system = [ setuptools-scm ];

  # To prevent infinite recursion with pytest
  doCheck = false;
  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = {
    changelog = "https://github.com/pytest-dev/pluggy/blob/${src.rev}/CHANGELOG.rst";
    description = "Plugin and hook calling mechanisms for Python";
    homepage = "https://github.com/pytest-dev/pluggy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
