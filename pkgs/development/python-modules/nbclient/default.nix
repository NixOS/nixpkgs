{ async_generator
, buildPythonPackage
, fetchFromGitHub
, hatchling
, ipykernel
, ipywidgets
, jupyter-client
, jupyter_core
, lib
, nbconvert
, nbformat
, nest-asyncio
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, testpath
, traitlets
, xmltodict
, flaky
}:

let nbclient = buildPythonPackage rec {
  pname = "nbclient";
  version = "0.7.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jupyter";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-yUaKc2T3eFgUKABJgu2DkXKiywGv3tZbRJk8L3wF77Y=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    async_generator
    traitlets
    nbformat
    nest-asyncio
    jupyter-client
    jupyter_core
  ];

  # circular dependencies if enabled by default
  doCheck = false;

  nativeCheckInputs = [
    ipykernel
    ipywidgets
    nbconvert
    pytest-asyncio
    pytestCheckHook
    testpath
    xmltodict
    flaky
  ];

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
    maintainers = [ ];
  };
};
in nbclient
