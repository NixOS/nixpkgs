{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, watchdog
}:

buildPythonPackage rec {
  pname = "hupper";
  version = "1.10.3";

  src = fetchFromGitHub {
     owner = "Pylons";
     repo = "hupper";
     rev = "1.10.3";
     sha256 = "1kvnry8svh6mzja4mm77g81y7n666zgbqry128n9qdqsg273c6v1";
  };

  # FIXME: watchdog dependency is disabled on Darwin because of #31865, which causes very silent
  # segfaults in the testsuite that end up failing the tests in a background thread (in myapp)
  checkInputs = [
    pytestCheckHook
  ] ++ lib.optional (!stdenv.isDarwin) [
    watchdog
  ];

  disabledTestPaths = [
    # Doesn't work with an exported home, RuntimeError: timeout waiting for change to file=/build/tmpgfn145cx
    "tests/test_it.py"
  ];

  pythonImportsCheck = [ "hupper" ];

  meta = with lib; {
    description = "In-process file monitor/reloader for reloading your code automatically during development";
    homepage = "https://github.com/Pylons/hupper";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
