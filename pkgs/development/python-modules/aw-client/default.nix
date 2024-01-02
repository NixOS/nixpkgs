{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, aw-core
, requests
, persist-queue
, click
, tabulate
, typing-extensions
, pytestCheckHook
, gitUpdater
}:

buildPythonPackage rec {
  pname = "aw-client";
  version = "0.5.13";

  format = "pyproject";

  # pypi distribution doesn't include tests, so build from source instead
  src = fetchFromGitHub {
    owner = "ActivityWatch";
    repo = "aw-client";
    rev = "v${version}";
    sha256 = "sha256-A9f1Wj4F6qRvCVj3iRQvsnILewJK1L5tfI2MnAXZ4nY=";
  };

  disabled = pythonOlder "3.8";

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aw-core
    requests
    persist-queue
    click
    tabulate
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Only run this test, the others are integration tests that require
  # an instance of aw-server running in order to function.
  pytestFlagsArray = [ "tests/test_requestqueue.py" ];

  preCheck = ''
    # Fake home folder for tests that write to $HOME
    export HOME="$TMPDIR"
  '';

  pythonImportsCheck = [ "aw_client" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Client library for ActivityWatch";
    homepage = "https://github.com/ActivityWatch/aw-client";
    maintainers = with maintainers; [ huantian ];
    license = licenses.mpl20;
  };
}
