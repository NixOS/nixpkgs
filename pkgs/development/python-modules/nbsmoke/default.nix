{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  jupyter-client,
  ipykernel,
  holoviews,
  nbformat,
  nbconvert,
  pyflakes,
  requests,
  beautifulsoup4,
}:

buildPythonPackage rec {
  pname = "nbsmoke";
  version = "0.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-i1UzPi+s4nvH/4DCZsRoylYzlHywaXcnNIAg3URbCHQ=";
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
    maintainers = [ ];
  };
}
