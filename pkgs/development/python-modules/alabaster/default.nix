{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
}:

buildPythonPackage rec {
  pname = "alabaster";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sphinx-doc";
    repo = "alabaster";
    rev = "refs/tags/${version}";
    hash = "sha256-aQEhFZUJs0TptfpjQVoIVI9V9a+xKjE2OfStSaJKHGI=";
  };

  build-system = [ flit-core ];

  pythonImportsCheck = [ "alabaster" ];

  # No tests included
  doCheck = false;

  meta = {
    changelog = "https://github.com/sphinx-doc/alabaster/blob/${src.rev}/docs/changelog.rst";
    homepage = "https://github.com/sphinx-doc/alabaster";
    description = "Light, configurable Sphinx theme";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.sphinx ];
  };
}
