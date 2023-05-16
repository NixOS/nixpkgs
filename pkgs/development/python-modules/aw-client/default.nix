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
<<<<<<< HEAD
, gitUpdater
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "aw-client";
<<<<<<< HEAD
  version = "0.5.12";
=======
  version = "0.5.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  format = "pyproject";

  # pypi distribution doesn't include tests, so build from source instead
  src = fetchFromGitHub {
    owner = "ActivityWatch";
    repo = "aw-client";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Aketk+itfd9gs3s+FDfzmGNWd7tKJQqNn1XsH2VTBD8=";
=======
    sha256 = "sha256-5WKGRoZGY+QnnB1Jzlju5OmCJreYMD8am2kW3Wcjhlw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Client library for ActivityWatch";
    homepage = "https://github.com/ActivityWatch/aw-client";
    maintainers = with maintainers; [ huantian ];
    license = licenses.mpl20;
  };
}
