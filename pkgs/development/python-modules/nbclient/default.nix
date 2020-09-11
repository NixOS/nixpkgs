{ stdenv, buildPythonPackage, fetchPypi, pythonOlder,
  async_generator, traitlets, nbformat, nest-asyncio, jupyter_client,
  pytest, xmltodict, nbconvert, ipywidgets
}:

buildPythonPackage rec {
  pname = "nbclient";
  version = "0.4.3";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "311e14e463a300239c558a95023f6d1007c3f69f589bd51a76b1b6b3f19a7f4b";
  };

  checkInputs = [ pytest xmltodict nbconvert ipywidgets ];
  propagatedBuildInputs = [ async_generator traitlets nbformat nest-asyncio jupyter_client ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/jupyter/nbclient";
    description = "A client library for executing notebooks";
    license = licenses.bsd3;
  };
}
