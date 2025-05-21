{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  # build inputs
  jupyter-client,
  nbformat,
  nbconvert,
  setuptools,
  # check inputs
  unittestCheckHook,
  ipykernel,
}:
let
  pname = "nbexec";
  version = "0.2.0";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jsvine";
    repo = "nbexec";
    tag = "v${version}";
    hash = "sha256-Vv6EHX6WlnSmzQAYlO1mHnz5t078z3RQfVfte1+X2pw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jupyter-client
    nbformat
    nbconvert
  ];

  # TODO there is a warning about debugpy_stream missing
  nativeCheckInputs = [
    unittestCheckHook
    ipykernel
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  unittestFlagsArray = [
    "-s"
    "test"
    "-v"
  ];

  pythonImportsCheck = [ "nbexec" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Dead-simple tool for executing Jupyter notebooks from the command line";
    mainProgram = "nbexec";
    homepage = "https://github.com/jsvine/nbexec";
    changelog = "https://github.com/jsvine/nbexec/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
