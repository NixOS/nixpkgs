{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build-system
, setuptools

# dependencies
, pyyaml
, unicode-rbnf

# tests
, pytestCheckHook
}:

let
  pname = "hassil";
  version = "1.7.0";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "hassil";
    rev = "refs/tags/${version}";
    hash = "sha256-v9MhW+6sEdZkscMvT9scqKLIUmIyTwXyYPcDK4b4faY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pyyaml
    unicode-rbnf
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    changelog  = "https://github.com/home-assistant/hassil/blob/v${version}/CHANGELOG.md";
    description = "Intent parsing for Home Assistant";
    mainProgram = "hassil";
    homepage = "https://github.com/home-assistant/hassil";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
  };
}
