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
  version = "0.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-i0dVPxztB3zXxFN/1dcB1G92gfJLKCdeXMHTR+fJtGs=";
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
