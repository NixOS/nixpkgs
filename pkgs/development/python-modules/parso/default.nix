{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "parso";
  version = "0.8.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2b6db14759c528d857eeb9eac559c2166b2554548af39f5198bdfb976f72aa64";
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
