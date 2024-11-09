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
  pythonOlder,
  requests,
  ruamel-yaml,
  semver,
  setuptools,
  toml,
  traitlets,
}:

buildPythonPackage rec {
  pname = "jupyter-repo2docker";
  version = "2024.07.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jupyterhub";
    repo = "repo2docker";
    rev = "refs/tags/${version}";
    hash = "sha256-ZzZBuJBPDG4to1fSYn2xysupXbPS9Q6wqWr3Iq/Vds8=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "Turn code repositories into Jupyter enabled Docker Images";
    homepage = "https://repo2docker.readthedocs.io/";
    changelog = "https://github.com/jupyterhub/repo2docker/blob/${src.rev}/docs/source/changelog.md";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
