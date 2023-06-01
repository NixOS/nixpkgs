{ buildPythonPackage
, callPackage
, pytest-cov
, fetchPypi
, lib
, pytest
, pythonOlder
, pytest-runner
}:

buildPythonPackage rec {
  pname = "pycategories";
  version = "1.2.0";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bd70ecb5e94e7659e564ea153f0c7673291dc37c526c246800fc08d6c5378099";
  };

  nativeBuildInputs = [ pytest-runner ];

  # Is private because the author states it's unmaintained
  # and shouldn't be used in production code
  propagatedBuildInputs = [ (callPackage ./infix.nix { }) ];

  nativeCheckInputs = [ pytest pytest-cov ];

  meta = with lib; {
    homepage = "https://gitlab.com/danielhones/pycategories";
    description = "Implementation of some concepts from category theory";
    license = licenses.mit;
    maintainers = with maintainers; [ dmvianna ];
  };
}
