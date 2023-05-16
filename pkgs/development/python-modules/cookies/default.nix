<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, pytestCheckHook
}:
=======
{ lib, buildPythonPackage, fetchPypi }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildPythonPackage rec {
  pname = "cookies";
  version = "2.2.1";
<<<<<<< HEAD
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1raYeIyuTPpOYu+GQ6nKMyt5vZbLMUKUuGSujX6z7o4=";
  };

  patches = [
    (fetchpatch {
      name = "fix-deprecations.patch";
      url = "https://gitlab.com/sashahart/cookies/-/commit/22543d970568d577effe120c5a34636a38aa397b.patch";
      hash = "sha256-8e3haOnbSXlL/ZY4uv6P4+ABBKrsCjbEpsLHaulbIUk=";
    })
  ];

  nativeBuildInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # https://gitlab.com/sashahart/cookies/-/issues/6
    "test_encoding_assumptions"
  ];
=======

  src = fetchPypi {
    inherit pname version;
    sha256 = "13pfndz8vbk4p2a44cfbjsypjarkrall71pgc97glk5fiiw9idnn";
  };

  doCheck = false;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Friendlier RFC 6265-compliant cookie parser/renderer";
    homepage = "https://github.com/sashahart/cookies";
    license = licenses.mit;
  };
}
