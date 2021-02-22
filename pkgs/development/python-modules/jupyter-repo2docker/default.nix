{ lib, buildPythonPackage, fetchPypi, pythonAtLeast
, docker
, escapism
, jinja2
, pkgs-docker
, python-json-logger
, pyyaml
, ruamel_yaml
, semver
, toml
, traitlets
}:

buildPythonPackage rec {
  version = "2021.1.0";
  pname = "jupyter-repo2docker";
  disabled = !(pythonAtLeast "3.4");

  src = fetchPypi {
    inherit pname version;
    sha256 = "3e3e671407ef2a7f7695338dc6ce2ca9cc75683ffc7a543829cf119564aca802";
  };

  propagatedBuildInputs = [
    docker
    escapism
    jinja2
    pkgs-docker
    python-json-logger
    ruamel_yaml
    semver
    toml
    traitlets
  ];

  # tests not packaged with pypi release
  doCheck = false;

  pythonImportsCheck = [
    "repo2docker"
    "repo2docker.app"
    "repo2docker.utils"
    "repo2docker.contentproviders.base"
  ];

  meta = with lib; {
    homepage = "https://repo2docker.readthedocs.io/en/latest/";
    description = "Repo2docker: Turn code repositories into Jupyter enabled Docker Images";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
