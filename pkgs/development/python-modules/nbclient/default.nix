{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  ipykernel,
  ipywidgets,
  jupyter-client,
  jupyter-core,
  lib,
  nbconvert,
  nbformat,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  testpath,
  traitlets,
  xmltodict,
}:

let
  nbclient = buildPythonPackage rec {
    pname = "nbclient";
    version = "0.10.2";
    pyproject = true;

    disabled = pythonOlder "3.9";

    src = fetchFromGitHub {
      owner = "jupyter";
      repo = "nbclient";
      tag = "v${version}";
      hash = "sha256-+qSed6yy4YVZ25GigNTap+kMaoDiMYSJO85wurbzeDs=";
    };

    build-system = [ hatchling ];

    dependencies = [
      jupyter-client
      jupyter-core
      nbformat
      traitlets
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
      check = nbclient.overridePythonAttrs (_: {
        doCheck = true;
      });
    };

    meta = {
      homepage = "https://github.com/jupyter/nbclient";
      description = "Client library for executing notebooks";
      mainProgram = "jupyter-execute";
      license = lib.licenses.bsd3;
      maintainers = [ ];
    };
  };
in
nbclient
