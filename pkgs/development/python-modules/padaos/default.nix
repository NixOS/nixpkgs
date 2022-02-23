{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

let
  pname = "padaos";
  version = "0.1.10";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "MycroftAI";
    repo = "padaos";
    rev = "v${version}";
    hash = "sha256-fzKewg0olo15b8ce/FMM/0acotSzIYePVq3Arh1lDxM=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A rigid, lightweight, dead-simple intent parser";
    homepage = "https://github.com/MycroftAI/padaos";
    license = licenses.mit;
    maintainers = teams.mycroft.members;
  };
}
