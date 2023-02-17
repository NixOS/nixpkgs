{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, watchdog
}:

buildPythonPackage rec {
  pname = "hupper";
  version = "1.10.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zW9Rtyx1h7ybzopl7NAloelfGwMoRRm/6RKE0BAxbNk=";
  };

  # FIXME: watchdog dependency is disabled on Darwin because of #31865, which causes very silent
  # segfaults in the testsuite that end up failing the tests in a background thread (in myapp)
  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.optionals (!stdenv.isDarwin) [
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
