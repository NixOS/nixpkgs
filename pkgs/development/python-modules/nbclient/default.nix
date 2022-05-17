{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, async_generator
, traitlets
, nbformat
, nest-asyncio
, jupyter-client
, pytestCheckHook
, xmltodict
, nbconvert
, ipywidgets
}:

let nbclient = buildPythonPackage rec {
  pname = "nbclient";
  version = "0.6.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uAcm/B+4mg6Pi+HnfijQAmsejtkLwUPIoMdiLk+M3Z4=";
  };

  propagatedBuildInputs = [ async_generator traitlets nbformat nest-asyncio jupyter-client ];

  # circular dependencies if enabled by default
  doCheck = false;

  checkInputs = [ pytestCheckHook xmltodict nbconvert ipywidgets ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  passthru.tests = {
    check = nbclient.overridePythonAttrs (_: { doCheck = true; });
  };

  meta = with lib; {
    homepage = "https://github.com/jupyter/nbclient";
    description = "A client library for executing notebooks";
    license = licenses.bsd3;
    maintainers = [ maintainers.erictapen ];
  };
};
in nbclient
