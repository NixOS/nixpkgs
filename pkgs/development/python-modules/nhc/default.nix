{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  nclib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nhc";
  version = "0.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vandeurenglenn";
    repo = "nhc";
    tag = "v${version}";
    hash = "sha256-TSfOcSeedr0cSDHo1bqftUOZ3AeCW3Zgb80IBv3eerM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    nclib
  ];

  pythonImportsCheck = [ "nhc" ];

  # upstream has no test
  doCheck = false;

  meta = {
    changelog = "https://github.com/vandeurenglenn/nhc/blob/${src.tag}/CHANGELOG.md";
    description = "SDK for Niko Home Control";
    homepage = "https://github.com/vandeurenglenn/nhc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
