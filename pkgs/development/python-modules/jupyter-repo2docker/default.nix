{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs-docker
, docker
, traitlets
, python-json-logger
, escapism
, jinja2
, ruamel_yaml
, pyyaml
, pytest
, wheel
, pytestcov
, pythonAtLeast
}:

buildPythonPackage rec {
  version = "0.7.0";
  pname = "jupyter-repo2docker";
  disabled = !(pythonAtLeast "3.4");

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf93ddf283de8c6b8f4ad983f8bf9b7b2a2c37812e387c245f8ba229d4f180c4";
  };

  checkInputs = [ pytest pyyaml wheel pytestcov ];
  propagatedBuildInputs = [ pkgs-docker docker traitlets python-json-logger escapism jinja2 ruamel_yaml ];

  # tests not packaged with pypi release
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://repo2docker.readthedocs.io/en/latest/;
    description = "Repo2docker: Turn code repositories into Jupyter enabled Docker Images";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
