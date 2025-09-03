{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  beautifulsoup4,
  mkdocs,
}:

buildPythonPackage rec {
  pname = "mkdocs-backlinks";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "danodic-dev";
    repo = "mkdocs-backlinks";
    tag = "v${version}";
    hash = "sha256-P3CUm7jpmcgipn/SKpZMWhpEqJSpirADMpud10ULXDs=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    beautifulsoup4
    mkdocs
  ];

  pythonImportsCheck = [
    "backlinks_plugin"
  ];

  # No tests available
  doCheck = false;

  meta = {
    description = "Plugin for adding backlinks to mkdocs";
    homepage = "https://github.com/danodic-dev/mkdocs-backlinks/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
