{
  lib,
  buildPythonPackage,
  chardet,
  docker,
  entrypoints,
  escapism,
  fetchFromGitHub,
  iso8601,
  jinja2,
  pkgs-docker,
  python-json-logger,
  requests,
  ruamel-yaml,
  semver,
  setuptools,
  setuptools-scm,
  toml,
  traitlets,
}:

buildPythonPackage rec {
  pname = "jupyter-repo2docker";
  version = "2026.04.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyterhub";
    repo = "repo2docker";
    tag = version;
    hash = "sha256-6atgsiCbT1qwxoMaPaHgwP0tilQDVkH9QCjwpEAOzg4=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    chardet
    docker
    entrypoints
    escapism
    iso8601
    jinja2
    pkgs-docker
    python-json-logger
    requests
    ruamel-yaml
    semver
    toml
    traitlets
  ];

  # Tests require a running Docker instance
  doCheck = false;

  pythonImportsCheck = [
    "repo2docker"
    "repo2docker.app"
    "repo2docker.utils"
    "repo2docker.contentproviders.base"
  ];

  meta = {
    description = "Turn code repositories into Jupyter enabled Docker Images";
    homepage = "https://repo2docker.readthedocs.io/";
    changelog = "https://github.com/jupyterhub/repo2docker/blob/${src.tag}/docs/source/changelog.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
