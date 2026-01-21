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
  testpath,
  traitlets,
  xmltodict,
}:

let
  nbclient = buildPythonPackage rec {
    pname = "nbclient";
    version = "0.10.4";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "jupyter";
      repo = "nbclient";
      tag = "v${version}";
      hash = "sha256-D7pgrNRrPT0fGOaHrNt3qeDXdbt1wJk5qfkQeLxsc7g=";
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
