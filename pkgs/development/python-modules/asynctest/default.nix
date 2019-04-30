{ lib, buildPythonPackage, fetchPypi, pythonOlder, python }:

buildPythonPackage rec {
  pname = "asynctest";
  version = "0.12.4";

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ade427a711d18016f35fb0c5d412f0ed63fb074a6084b67ff2dad48f50b0d6ca";
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
