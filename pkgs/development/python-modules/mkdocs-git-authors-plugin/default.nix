{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  mkdocs,
}:

buildPythonPackage rec {
  pname = "mkdocs-git-authors-plugin";
  version = "0.9.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "timvink";
    repo = "mkdocs-git-authors-plugin";
    tag = "v${version}";
    hash = "sha256-2ITro34lZ+tz7ev7Yuh1wJjsSNik6VUTt3dupIajmLU=";
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
