{ lib, buildPythonPackage, fetchFromGitHub
, beautifulsoup4
, jsbeautifier
, mkdocs
, mkdocs-material
, pymdown-extensions
, pyyaml
, requests
}:

buildPythonPackage rec {
  pname = "mkdocs-mermaid2-plugin";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "fralau";
    repo = "mkdocs-mermaid2-plugin";
    rev = "refs/tags/v${version}";
    hash = "sha256-8/5lltOT78VSMxunIfCeGSBQ7VIRVnk3cHIzd7S+c00=";
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
    description = "A MkDocs plugin for including mermaid graphs in markdown sources";
    homepage = "https://github.com/fralau/mkdocs-mermaid2-plugin";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
