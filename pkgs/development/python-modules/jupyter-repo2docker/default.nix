{ lib, buildPythonPackage, fetchPypi, pythonOlder
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
  version = "2021.8.0";
  pname = "jupyter-repo2docker";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9d1b3c3ec7944ea6b0a234d6fa77293a2d1ed1c080eba8466aba94f811b3465d";
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
