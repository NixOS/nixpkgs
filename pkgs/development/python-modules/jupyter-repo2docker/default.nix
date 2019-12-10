{ stdenv, buildPythonPackage, fetchPypi, pythonAtLeast
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
  version = "0.10.0";
  pname = "jupyter-repo2docker";
  disabled = !(pythonAtLeast "3.4");

  src = fetchPypi {
    inherit pname version;
    sha256 = "7965262913be6be60e64c8016f5f3d4bf93701f2787209215859d73b2adbc05a";
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

  meta = with stdenv.lib; {
    homepage = https://repo2docker.readthedocs.io/en/latest/;
    description = "Repo2docker: Turn code repositories into Jupyter enabled Docker Images";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
