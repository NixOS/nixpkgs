{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  ...
}:
buildPythonPackage {
  name = "mpmath";
  version = "1.3.0";
  pyproject = true;

  build-system = [
    setuptools
  ];

  src = fetchFromGitHub {
    owner = "mpmath";
    repo = "mpmath";
    tag = "1.3.0";
    hash = "sha256-9BGcaC3TyolGeO65/H42T/WQY6z5vc1h+MA+8MGFChU=";
  };
}
