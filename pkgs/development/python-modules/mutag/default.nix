{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyparsing,
  pythonOlder,
  setuptools,
}:

buildPythonPackage {
  pname = "mutag";
  version = "0.0.2-unstable-2018-08-20";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aroig";
    repo = "mutag";
    rev = "9425169eb5d4aa9eb09f2809a09b83855b3acbef";
    hash = "sha256-fEMmFRoFyLkqusAuhdx3XEPaPsu1x86ACAz9Vkl9YfA=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyparsing ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "mutag" ];

  meta = with lib; {
    description = "Script to change email tags in a mu indexed maildir";
    homepage = "https://github.com/aroig/mutag";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "mutag";
  };
}
