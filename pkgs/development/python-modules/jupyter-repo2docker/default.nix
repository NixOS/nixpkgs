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
  version = "0.10.0";
  pname = "jupyter-repo2docker";
  disabled = !(pythonAtLeast "3.4");

  src = fetchPypi {
    inherit pname version;
    sha256 = "7965262913be6be60e64c8016f5f3d4bf93701f2787209215859d73b2adbc05a";
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
