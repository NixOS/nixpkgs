{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nhc";
  version = "0.4.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vandeurenglenn";
    repo = "nhc";
    tag = version;
    hash = "sha256-g9uSAk1YTBDnGRfQQkEu1XMMN3MYYDWJoOJ+Ga7jXRw=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "nhc" ];

  # upstream has no test
  doCheck = false;

  meta = {
    changelog = "https://github.com/VandeurenGlenn/nhc/blob/${src.tag}/CHANGELOG.md";
    description = "SDK for Niko Home Control";
    homepage = "https://github.com/vandeurenglenn/nhc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
