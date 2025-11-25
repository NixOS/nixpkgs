{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mkdocs,
  setuptools,
}:
buildPythonPackage rec {
  pname = "mkdocs-simple-blog";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FernandoCelmer";
    repo = "mkdocs-simple-blog";
    tag = "v${version}";
    hash = "sha256-pzoQb5cBzd7Gt2jbai4cr37i5n30y0lfaukhQETSsjA=";
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
    changelog = "https://github.com/FernandoCelmer/mkdocs-simple-blog/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
