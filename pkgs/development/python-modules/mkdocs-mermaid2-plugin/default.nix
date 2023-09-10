{ lib
, buildPythonPackage
, fetchFromGitHub
, beautifulsoup4
, jsbeautifier
, mkdocs
, mkdocs-material
, pymdown-extensions
, pyyaml
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mkdocs-mermaid2-plugin";
  version = "1.0.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fralau";
    repo = "mkdocs-mermaid2-plugin";
    rev = "refs/tags/v${version}";
    hash = "sha256-0h/EMfp6D14ZJcQe3U2r/RQ/VNejOK9bLP6AMNiB0Rc=";
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

  pythonImportsCheck = [
    "mermaid2"
  ];

  meta = with lib; {
    description = "A MkDocs plugin for including mermaid graphs in markdown sources";
    homepage = "https://github.com/fralau/mkdocs-mermaid2-plugin";
    changelog = "https://github.com/fralau/mkdocs-mermaid2-plugin/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
