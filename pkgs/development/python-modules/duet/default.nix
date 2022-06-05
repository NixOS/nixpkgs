{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, typing-extensions
}:

buildPythonPackage rec {
  pname = "duet";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "duet";
    rev = "v${version}";
    sha256 = "sha256-hK2Cx7dSm1mGM2z9oCoRogfa2aIsjyJcdpSSfdHhPmw=";
  };

  propagatedBuildInputs = [ typing-extensions ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A simple future-based async library for python";
    homepage = "https://github.com/google/duet";
    maintainers = with maintainers; [ drewrisinger ];
  };
}
