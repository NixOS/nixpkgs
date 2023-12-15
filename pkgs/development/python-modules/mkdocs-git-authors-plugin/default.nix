{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, mkdocs
}:

buildPythonPackage rec {
  pname = "mkdocs-git-authors-plugin";
  version = "0.7.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "timvink";
    repo = "mkdocs-git-authors-plugin";
    rev = "v${version}";
    hash = "sha256-jhYwi9HO6kxOS1QmEKb1YnXGSJ4Eyo4Sm07jI4lxXnA=";
  };

  propagatedBuildInputs = [ mkdocs ];

  pythonImportsCheck = [ "mkdocs_git_authors_plugin" ];

  meta = with lib; {
    description = "Lightweight MkDocs plugin to display git authors of a markdown page";
    homepage = "https://github.com/timvink/mkdocs-git-authors-plugin";
    license = licenses.mit;
    maintainers = with maintainers; [ totoroot ];
  };
}
