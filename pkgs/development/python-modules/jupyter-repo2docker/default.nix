{ lib
, bash
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
, pyyaml
, ruamel_yaml
, semver
, toml
, traitlets
}:

buildPythonPackage rec {
  version = "2021.08.0";
  pname = "jupyter-repo2docker";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jupyterhub";
    repo = "repo2docker";
    rev = version;
    sha256 = "10hcdag7ivyqyiqrmr9c48zynp8d81ic3px1ffgnaysih7lvkwb6";
  };

  propagatedBuildInputs = [
    docker
    entrypoints
    escapism
    iso8601
    jinja2
    pkgs-docker
    python-json-logger
    ruamel_yaml
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
