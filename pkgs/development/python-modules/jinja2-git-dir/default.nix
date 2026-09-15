{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  jinja2,
  hatchling,
}:

buildPythonPackage rec {
  pname = "jinja2-git-dir";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gordon-code";
    repo = "jinja2-git-dir";
    tag = "v${version}";
    hash = "sha256-YYdwZ0Hypd2fihpsQ6gPht6vHqcpeYP41TahC9jgxzQ=";
  };

  build-system = [ hatchling ];

  dependencies = [ jinja2 ];

  # Tests require a git repo
  doCheck = false;

  pythonImportsCheck = [ "jinja2_git_dir" ];

  meta = {
    homepage = "https://github.com/gordon-code/jinja2-git-dir/";
    description = "Jinja2 filter extension for detecting if a directory is a git repository";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.wgordon17 ];
  };
}
