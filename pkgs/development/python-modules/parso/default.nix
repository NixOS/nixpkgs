{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "parso";
  version = "0.8.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8519430ad07087d4c997fda3a7918f7cfa27cb58972a8c89c2a0295a1c940e9e";
  };

  patches = [
    # Fix the flaky test due to slow moving time on Apple Silicon chips.
    # Remove when https://github.com/davidhalter/parso/pull/177 is in the next release.
    (fetchpatch {
      url = "https://github.com/davidhalter/parso/pull/177/commits/2799a7a3c2cf87fdc2d0c19a0890acea425091ce.patch";
      sha256 = "sha256-A5EQly1wR/7lo+L8Pp0UPSUIhC0WcblXEWQNvRMlZYA=";
    })
  ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A Python Parser";
    homepage = "https://parso.readthedocs.io/en/latest/";
    changelog = "https://github.com/davidhalter/parso/blob/master/CHANGELOG.rst";
    license = licenses.mit;
  };
}
