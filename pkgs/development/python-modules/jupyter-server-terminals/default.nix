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
  self = buildPythonPackage (finalAttrs: {
    pname = "jupyter-server-terminals";
    version = "0.5.4";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "jupyter-server";
      repo = "jupyter_server_terminals";
      tag = "v${finalAttrs.version}";
      hash = "sha256-gVR34Ajfv567isVmbP7Zx4AiptrdNqd032QxdMBpsTE=";
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

    meta = {
      changelog = "https://github.com/jupyter-server/jupyter_server_terminals/releases/tag/${finalAttrs.src.tag}";
      description = "Jupyter Server Extension Providing Support for Terminals";
      homepage = "https://github.com/jupyter-server/jupyter_server_terminals";
      license = lib.licenses.bsd3;
      maintainers = [ ];
    };
  });
in
self
