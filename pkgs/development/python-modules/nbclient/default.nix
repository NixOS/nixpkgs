{ async-generator
, buildPythonPackage
, fetchFromGitHub
, hatchling
, ipykernel
, ipywidgets
, jupyter-client
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
}:

let nbclient = buildPythonPackage rec {
  pname = "nbclient";
  version = "0.8.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jupyter";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-uBCYmrl/Zfw58hd12z20jLVwGSPv+M3fMo1mfV2GO/M=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    async-generator
    traitlets
    nbformat
    nest-asyncio
    jupyter-client
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
