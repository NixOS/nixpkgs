{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mkdocs,
  setuptools,
}:
buildPythonPackage rec {
  pname = "mkdocs-simple-blog";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FernandoCelmer";
    repo = "mkdocs-simple-blog";
    tag = "v${version}";
    hash = "sha256-1RzorEsGXA8mRzMSS9S5vbPqJXK0vPMlRixo+Yrq27U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    mkdocs
  ];

  # This package has no tests
  doCheck = false;

  pythonImportsCheck = [ "mkdocs_simple_blog" ];

  meta = {
    description = "Simple blog generator plugin for MkDocs";
    homepage = "https://fernandocelmer.github.io/mkdocs-simple-blog/";
    changelog = "https://github.com/FernandoCelmer/mkdocs-simple-blog/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
