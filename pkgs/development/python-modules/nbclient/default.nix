{ stdenv, buildPythonPackage, fetchPypi, pythonOlder,
  async_generator, traitlets, nbformat, nest-asyncio, jupyter_client,
  pytest, xmltodict, nbconvert, ipywidgets
}:

buildPythonPackage rec {
  pname = "nbclient";
  version = "0.4.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "31fdb4bd45ebcd98eeda01e2c38fb391eae8a8480bdddbebb6cfd088486948a7";
  };

  checkInputs = [ pytest xmltodict nbconvert ipywidgets ];
  propagatedBuildInputs = [ async_generator traitlets nbformat nest-asyncio jupyter_client ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/jupyter/nbclient";
    description = "A client library for executing notebooks";
    license = licenses.bsd3;
  };
}
