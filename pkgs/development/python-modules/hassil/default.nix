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
  version = "3.11.0";
in
buildPythonPackage rec {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OHF-Voice";
    repo = "hassil";
    tag = "v${version}";
    hash = "sha256-+9ZY2K2LBf1nlZgwcV6d6dpYhm5FGJrAZ/8142sYFDg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
    unicode-rbnf
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/OHF-Voice/hassil/blob/${src.tag}/CHANGELOG.md";
    description = "Intent parsing for Home Assistant";
    mainProgram = "hassil";
    homepage = "https://github.com/OHF-Voice/hassil";
    license = lib.licenses.asl20;
    teams = [ lib.teams.home-assistant ];
  };
}
