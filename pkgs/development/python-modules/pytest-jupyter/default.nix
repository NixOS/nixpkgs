{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build
  hatchling,
  pytest,

  # runtime
  jupyter-core,

  # optionals
  jupyter-client,
  ipykernel,
  jupyter-server,
  nbformat,

  # tests
  pytest-timeout,
  pytestCheckHook,
}:

let
  self = buildPythonPackage rec {
    pname = "pytest-jupyter";
    version = "0.10.1";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "jupyter-server";
      repo = "pytest-jupyter";
      tag = "v${version}";
      hash = "sha256-RTpXBbVCRj0oyZ1TXXDv3M7sAI4kA6f3ouzTr0rXjwY=";
    };

    nativeBuildInputs = [ hatchling ];

    buildInputs = [ pytest ];

    propagatedBuildInputs = [ jupyter-core ];

    optional-dependencies = {
      client = [
        jupyter-client
        nbformat
        ipykernel
      ];
      server = [
        jupyter-server
        jupyter-client
        nbformat
        ipykernel
      ];
    };

    doCheck = false; # infinite recursion with jupyter-server

    nativeCheckInputs = [
      pytest-timeout
      pytestCheckHook
    ]
    ++ lib.concatAttrValues optional-dependencies;

    passthru.tests = {
      check = self.overridePythonAttrs (_: {
        doCheck = false;
      });
    };

    meta = with lib; {
      changelog = "https://github.com/jupyter-server/pytest-jupyter/releases/tag/v${version}";
      description = "Pytest plugin for testing Jupyter core libraries and extensions";
      homepage = "https://github.com/jupyter-server/pytest-jupyter";
      license = licenses.bsd3;
      maintainers = [ ];
    };
  };
in
self
