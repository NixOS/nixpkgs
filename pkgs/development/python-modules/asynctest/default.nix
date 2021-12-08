{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, python }:

buildPythonPackage rec {
  pname = "asynctest";
  version = "0.13.0";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
     owner = "Martiusweb";
     repo = "asynctest";
     rev = "v0.13.0";
     sha256 = "1mqip290iyc028drmrd5dy1ay08hdgvyfs04ncylcll86v64a5vz";
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
