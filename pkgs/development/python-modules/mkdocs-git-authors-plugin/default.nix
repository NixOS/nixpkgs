{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mkdocs,
  gitMinimal,
}:

buildPythonPackage rec {
  pname = "mkdocs-git-authors-plugin";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "timvink";
    repo = "mkdocs-git-authors-plugin";
    tag = "v${version}";
    hash = "sha256-Uy1XgSJchA7hkc9i4hE8Ws4OWY5GRzvfnhKkZvxT2d0=";
  };

  postPatch = ''
    substituteInPlace src/mkdocs_git_authors_plugin/git/command.py \
      --replace-fail 'args = ["git"]' 'args = ["${gitMinimal}/bin/git"]'
  '';

  build-system = [
    setuptools
  ];

  dependencies = [ mkdocs ];

  pythonImportsCheck = [ "mkdocs_git_authors_plugin" ];

  meta = {
    description = "Lightweight MkDocs plugin to display git authors of a markdown page";
    homepage = "https://github.com/timvink/mkdocs-git-authors-plugin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ totoroot ];
  };
}
