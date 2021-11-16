{ lib, buildPythonPackage, fetchPypi, pythonOlder,
  async_generator, traitlets, nbformat, nest-asyncio, jupyter-client,
  pytest, xmltodict, nbconvert, ipywidgets
, doCheck ? true
}:

buildPythonPackage rec {
  pname = "nbclient";
  version = "0.5.8";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NPUsycuDGl2MzXAxU341THXcYaJEh/mYcS0Sid4yCiU=";
  };

  inherit doCheck;
  checkInputs = [ pytest xmltodict nbconvert ipywidgets ];
  propagatedBuildInputs = [ async_generator traitlets nbformat nest-asyncio jupyter-client ];

  postFixup =  ''
    # Remove until fixed by upstream
    # https://github.com/jupyter/nbclient/pull/173#issuecomment-968760082
    rm $out/bin/.jupyter-run-wrapped
    rm $out/bin/jupyter-run
  '';

  meta = with lib; {
    homepage = "https://github.com/jupyter/nbclient";
    description = "A client library for executing notebooks";
    license = licenses.bsd3;
    maintainers = [ maintainers.erictapen ];
  };
}
