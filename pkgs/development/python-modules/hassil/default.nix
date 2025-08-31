{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  pyyaml,
  unicode-rbnf,

  # tests
  pytestCheckHook,
}:

let
  pname = "hassil";
  version = "3.2.0";
in
buildPythonPackage rec {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "hassil";
    tag = "v${version}";
    hash = "sha256-X+VOcgOFcdb29VfJCfD1xBEqY/1qbfwViS/N9PsT2y8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
    unicode-rbnf
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # infinite recursion with home-assistant.intents
    "tests/test_fuzzy.py"
  ];

  meta = with lib; {
    changelog = "https://github.com/home-assistant/hassil/blob/${src.tag}/CHANGELOG.md";
    description = "Intent parsing for Home Assistant";
    mainProgram = "hassil";
    homepage = "https://github.com/home-assistant/hassil";
    license = licenses.asl20;
    teams = [ teams.home-assistant ];
  };
}
