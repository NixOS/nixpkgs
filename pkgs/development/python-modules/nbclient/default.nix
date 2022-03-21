{ lib, buildPythonPackage, fetchPypi, pythonOlder,
  async_generator, traitlets, nbformat, nest-asyncio, jupyter-client,
  pytest, xmltodict, nbconvert, ipywidgets
, doCheck ? true
}:

buildPythonPackage rec {
  pname = "nbclient";
  version = "0.5.10";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b5fdea88d6fa52ca38de6c2361401cfe7aaa7cd24c74effc5e489cec04d79088";
  };

  inherit doCheck;
  checkInputs = [ pytest xmltodict nbconvert ipywidgets ];
  propagatedBuildInputs = [ async_generator traitlets nbformat nest-asyncio jupyter-client ];

  meta = with lib; {
    homepage = "https://github.com/jupyter/nbclient";
    description = "A client library for executing notebooks";
    license = licenses.bsd3;
    maintainers = [ maintainers.erictapen ];
  };
}
