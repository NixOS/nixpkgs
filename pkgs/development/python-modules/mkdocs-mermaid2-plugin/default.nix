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
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mkdocs-mermaid2-plugin";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fralau";
    repo = "mkdocs-mermaid2-plugin";
    rev = "refs/tags/v${version}";
    hash = "sha256-9vYLkGUnL+rnmZntcgFzOvXQdf6angb9DRsmrBjnPUY=";
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

  meta = with lib; {
    description = "MkDocs plugin for including mermaid graphs in markdown sources";
    homepage = "https://github.com/fralau/mkdocs-mermaid2-plugin";
    changelog = "https://github.com/fralau/mkdocs-mermaid2-plugin/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
