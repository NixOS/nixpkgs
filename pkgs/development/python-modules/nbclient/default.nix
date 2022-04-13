{ lib, buildPythonPackage, fetchPypi, pythonOlder,
  async_generator, traitlets, nbformat, nest-asyncio, jupyter-client,
  pytest, xmltodict, nbconvert, ipywidgets
}:

buildPythonPackage rec {
  pname = "nbclient";
  version = "0.6.2";
  # As of version 0.6.2, there is both a setup.py and pyproject.toml. However,
  # the pyproject.toml does not appear to be the main entry point.
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-i0dVPxztB3zXxFN/1dcB1G92gfJLKCdeXMHTR+fJtGs=";
  };

  doCheck = false; # Avoid infinite recursion
  checkInputs = [ pytest xmltodict nbconvert ipywidgets ];
  propagatedBuildInputs = [ async_generator traitlets nbformat nest-asyncio jupyter-client ];

  meta = with lib; {
    homepage = "https://github.com/jupyter/nbclient";
    description = "A client library for executing notebooks";
    license = licenses.bsd3;
    maintainers = [ maintainers.erictapen ];
  };
}
