{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build
  hatchling,

  # runtime
  terminado,

  # tests
  pytest-jupyter,
  pytest-timeout,
  pytestCheckHook,
}:

let
  self = buildPythonPackage rec {
    pname = "jupyter-server-terminals";
    version = "0.5.3";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "jupyter-server";
      repo = "jupyter_server_terminals";
      tag = "v${version}";
      hash = "sha256-af7jBscGkbekXgfDxwAfrJSY1uEuIGfzzSsjaPdlYcY=";
    };

    nativeBuildInputs = [ hatchling ];

    propagatedBuildInputs = [ terminado ];

    doCheck = false; # infinite recursion

    nativeCheckInputs = [
      pytest-jupyter
      pytest-timeout
      pytestCheckHook
    ]
    ++ pytest-jupyter.optional-dependencies.server;

    passthru.tests = {
      check = self.overridePythonAttrs (_: {
        doCheck = true;
      });
    };

    meta = with lib; {
      changelog = "https://github.com/jupyter-server/jupyter_server_terminals/releases/tag/v${version}";
      description = "Jupyter Server Extension Providing Support for Terminals";
      homepage = "https://github.com/jupyter-server/jupyter_server_terminals";
      license = licenses.bsd3;
      maintainers = [ ];
    };
  };
in
self
