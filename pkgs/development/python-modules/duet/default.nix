{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, typing-extensions
}:

buildPythonPackage rec {
  pname = "duet";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "google";
    repo = "duet";
    rev = "v${version}";
    sha256 = "sha256-9CTAupAxZI1twoLpgr7VfECw70QunE6pk+SskiT3JDw=";
  };

  propagatedBuildInputs = [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A simple future-based async library for python";
    homepage = "https://github.com/google/duet";
    maintainers = with maintainers; [ drewrisinger ];
  };
}
