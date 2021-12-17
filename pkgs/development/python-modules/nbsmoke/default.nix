{ lib
, buildPythonPackage
, fetchPypi
, pytest
, jupyter-client
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
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2400d7878e97714e822ab200a71fc71ede487e671f42b4b411745dba95f9cb32";
  };

  propagatedBuildInputs = [
    pytest
    holoviews
    jupyter-client
    ipykernel
    nbformat
    nbconvert
    pyflakes
    requests
    beautifulsoup4
  ];

  # tests not included with pypi release
  doCheck = false;
  pythonImportsCheck = [ "nbsmoke" ];

  meta = with lib; {
    description = "Basic notebook checks and linting";
    homepage = "https://github.com/pyviz/nbsmoke";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
