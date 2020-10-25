{ stdenv, buildPythonPackage, fetchPypi, pythonOlder,
  async_generator, traitlets, nbformat, nest-asyncio, jupyter_client,
  pytest, xmltodict, nbconvert, ipywidgets
}:

buildPythonPackage rec {
  pname = "nbclient";
  version = "0.5.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01e2d726d16eaf2cde6db74a87e2451453547e8832d142f73f72fddcd4fe0250";
  };

  checkInputs = [ pytest xmltodict nbconvert ipywidgets ];
  propagatedBuildInputs = [ async_generator traitlets nbformat nest-asyncio jupyter_client ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/jupyter/nbclient";
    description = "A client library for executing notebooks";
    license = licenses.bsd3;
  };
}
