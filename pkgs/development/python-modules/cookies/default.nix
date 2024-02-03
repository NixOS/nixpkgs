{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cookies";
  version = "2.2.1";
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

  meta = with lib; {
    description = "Friendlier RFC 6265-compliant cookie parser/renderer";
    homepage = "https://github.com/sashahart/cookies";
    license = licenses.mit;
  };
}
