{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  beautifulsoup4,
  jsbeautifier,
  mkdocs,
  mkdocs-material,
  pymdown-extensions,
  pyyaml,
  requests,
}:

buildPythonPackage rec {
  pname = "mkdocs-mermaid2-plugin";
  version = "1.2.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "fralau";
    repo = "mkdocs-mermaid2-plugin";
    tag = "v${version}";
    hash = "sha256-EsfcOnfjZpAndYccN8WTpfLoUAlc5JQkgoy1ro1hMRo=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    jsbeautifier
    mkdocs
    mkdocs-material
    pymdown-extensions
    pyyaml
    requests
  ];

  # non-traditional python tests (e.g. nodejs based tests)
  doCheck = false;

  pythonImportsCheck = [ "mermaid2" ];

  meta = {
    description = "MkDocs plugin for including mermaid graphs in markdown sources";
    homepage = "https://github.com/fralau/mkdocs-mermaid2-plugin";
    changelog = "https://github.com/fralau/mkdocs-mermaid2-plugin/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
