{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  hatchling,
  jupyter-events,
  jupyter-server,
  click,
  pytest-jupyter,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jupyter-server-fileid";
  version = "0.9.3";
  pyproject = true;

  disables = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jupyter-server";
    repo = "jupyter_server_fileid";
    rev = "refs/tags/v${version}";
    hash = "sha256-ob7hnqU7GdaDHEPF7+gwkmsboKZgiiLzzwxbBUwYHYo=";
  };

  build-system = [ hatchling ];

  dependencies = [
    jupyter-events
    jupyter-server
  ];

  optional-dependencies = {
    cli = [ click ];
  };

  pythonImportsCheck = [ "jupyter_server_fileid" ];

  checkInputs = [
    pytest-jupyter
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TEMPDIR
  '';

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/jupyter-server/jupyter_server_fileid/blob/${src.rev}/CHANGELOG.md";
    description = "Extension that maintains file IDs for documents in a running Jupyter Server";
    mainProgram = "jupyter-fileid";
    homepage = "https://github.com/jupyter-server/jupyter_server_fileid";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
