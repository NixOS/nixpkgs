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
  version = "3.7.0";
in
buildPythonPackage rec {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "hassil";
    tag = "v${version}";
    hash = "sha256-C3nx8w0y4RsHq9txwdSfgS9BMcY4TyZiBOq4QIq5w+0=";
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

  meta = {
    changelog = "https://github.com/home-assistant/hassil/blob/${src.tag}/CHANGELOG.md";
    description = "Intent parsing for Home Assistant";
    mainProgram = "hassil";
    homepage = "https://github.com/home-assistant/hassil";
    license = lib.licenses.asl20;
    teams = [ lib.teams.home-assistant ];
  };
}
