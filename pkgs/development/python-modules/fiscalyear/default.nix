{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "fiscalyear";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adamjstewart";
    repo = "fiscalyear";
    tag = "v${version}";
    hash = "sha256-2wejJRTmVHWiM8LoodyaOyMbMqCx5It6JHCQUWpGsxs=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "fiscalyear" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/adamjstewart/fiscalyear/releases/tag/${src.tag}";
    description = "Utilities for managing the fiscal calendar";
    homepage = "https://github.com/adamjstewart/fiscalyear";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
