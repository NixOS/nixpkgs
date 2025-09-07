{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  poetry-core,
  aw-core,
  requests,
  persist-queue,
  click,
  tabulate,
  typing-extensions,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aw-client";
  version = "0.5.15";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ActivityWatch";
    repo = "aw-client";
    tag = "v${version}";
    hash = "sha256-AS29DIfEQ6/vh8idcMMQoGmiRM8MMf3eVQzvNPsXgpA=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aw-core
    requests
    persist-queue
    click
    tabulate
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Only run this test, the others are integration tests that require
  # an instance of aw-server running in order to function.
  enabledTestPaths = [ "tests/test_requestqueue.py" ];

  preCheck = ''
    # Fake home folder for tests that write to $HOME
    export HOME="$TMPDIR"
  '';

  pythonImportsCheck = [ "aw_client" ];

  meta = with lib; {
    description = "Client library for ActivityWatch";
    homepage = "https://github.com/ActivityWatch/aw-client";
    changelog = "https://github.com/ActivityWatch/aw-client/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ huantian ];
    mainProgram = "aw-client";
  };
}
