{ lib
, buildPythonPackage
, fetchPypi
, pytest
, jupyter_client
, ipykernel
, nbformat
, nbconvert
, pyflakes
, requests
, beautifulsoup4
}:

buildPythonPackage rec {
  pname = "nbsmoke";
  version = "0.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "40891e556dc9e252da2a649028cacb949fc8efb81062ada7d9a87a01b08bb454";
  };

  propagatedBuildInputs = [
    pytest
    jupyter_client
    ipykernel
    nbformat
    nbconvert
    pyflakes
    requests
    beautifulsoup4
  ];

  # tests not included with pypi release
  doCheck = false;

  meta = with lib; {
    description = "Basic notebook checks and linting";
    homepage = https://github.com/pyviz/nbsmoke;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
