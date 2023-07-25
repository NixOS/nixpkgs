{ lib, buildPythonPackage, fetchPypi, pythonOlder, python, pythonAtLeast }:

buildPythonPackage rec {
  pname = "asynctest";
  version = "0.13.0";

  # Unmaintained and incompatible python 3.11
  disabled = pythonAtLeast "3.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b3zsy7p84gag6q8ai2ylyrhx213qdk2h2zb6im3xn0m5n264y62";
  };

  postPatch = ''
    # Skip failing test, probably caused by file system access
    substituteInPlace test/test_selector.py \
      --replace "test_events_watched_outside_test_are_ignored" "xtest_events_watched_outside_test_are_ignored"
  '';

  # https://github.com/Martiusweb/asynctest/issues/132
  doCheck = pythonOlder "3.7";

  checkPhase = ''
    ${python.interpreter} -m unittest test
  '';

  meta = with lib; {
    description = "Enhance the standard unittest package with features for testing asyncio libraries";
    homepage = "https://github.com/Martiusweb/asynctest";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
