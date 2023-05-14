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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "fralau";
    repo = "mkdocs-mermaid2-plugin";
    rev = "v${version}";
    hash = "sha256-Oe6wkVrsB0NWF+HHeifrEogjxdGPINRDJGkh9p+GoHs=";
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
