{ lib, buildPythonPackage, fetchPypi, pythonOlder, python }:

buildPythonPackage rec {
  pname = "asynctest";
  version = "0.12.3";

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bbeb45bb41344d2cbb814b4c89c04f2c568742352736cabf7af6fcbed06f66cc";
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
