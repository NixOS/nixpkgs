{ lib, buildPythonPackage, fetchPypi, pythonOlder,
  async_generator, traitlets, nbformat, nest-asyncio, jupyter-client,
  pytest, xmltodict, nbconvert, ipywidgets
, doCheck ? true
}:

buildPythonPackage rec {
  pname = "nbclient";
  version = "0.5.4";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6c8ad36a28edad4562580847f9f1636fe5316a51a323ed85a24a4ad37d4aefce";
  };

  inherit doCheck;
  checkInputs = [ pytest xmltodict nbconvert ipywidgets ];
  propagatedBuildInputs = [ async_generator traitlets nbformat nest-asyncio jupyter-client ];

  meta = with lib; {
    homepage = "https://github.com/jupyter/nbclient";
    description = "A client library for executing notebooks";
    license = licenses.bsd3;
  };
}
