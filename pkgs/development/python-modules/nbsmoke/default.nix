{ lib
, buildPythonPackage
, fetchPypi
, pytest
, jupyter_client
, ipykernel
, holoviews
, nbformat
, nbconvert
, pyflakes
, requests
, beautifulsoup4
}:

buildPythonPackage rec {
  pname = "nbsmoke";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "070e999db3902a0c62a94d76de8fb98da21eaee22d9e90eb42f1636c87e1b805";
  };

  propagatedBuildInputs = [
    pytest
    holoviews
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
