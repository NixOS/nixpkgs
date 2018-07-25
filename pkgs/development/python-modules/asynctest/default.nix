{ lib, buildPythonPackage, fetchPypi, pythonOlder, python }:

buildPythonPackage rec {
  pname = "asynctest";
  version = "0.12.2";

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "77520850ae21620ec31738f4a7b467acaa44de6d3752d8ac7a9f4dcf55d77853";
  };

  postPatch = ''
    # Skip failing test, probably caused by file system access
    substituteInPlace test/test_selector.py \
      --replace "test_events_watched_outside_test_are_ignored" "xtest_events_watched_outside_test_are_ignored"
  '';

  checkPhase = ''
    ${python.interpreter} -m unittest test
  '';

  meta = with lib; {
    description = "Enhance the standard unittest package with features for testing asyncio libraries";
    homepage = https://github.com/Martiusweb/asynctest;
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
