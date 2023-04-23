{ lib
, buildPythonPackage
, chardet
, docker
, entrypoints
, escapism
, fetchFromGitHub
, iso8601
, jinja2
, pkgs-docker
, python-json-logger
, pythonOlder
, ruamel-yaml
, semver
, toml
, traitlets
}:

buildPythonPackage rec {
  pname = "jupyter-repo2docker";
  version = "2022.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jupyterhub";
    repo = "repo2docker";
    rev = "refs/tags/${version}";
    hash = "sha256-n1Yhl3QC1YqdsCl6pI5NjzTiSEs6NrGq9jwT0uyS/p0=";
  };

  propagatedBuildInputs = [
    chardet
    docker
    entrypoints
    escapism
    iso8601
    jinja2
    pkgs-docker
    python-json-logger
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
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ costrouc ];
  };
}
