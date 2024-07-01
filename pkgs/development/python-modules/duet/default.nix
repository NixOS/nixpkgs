{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "duet";
  version = "0.2.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "google";
    repo = "duet";
    rev = "v${version}";
    hash = "sha256-9CTAupAxZI1twoLpgr7VfECw70QunE6pk+SskiT3JDw=";
  };

  propagatedBuildInputs = [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Simple future-based async library for python";
    homepage = "https://github.com/google/duet";
    maintainers = with maintainers; [ drewrisinger ];
  };
}
