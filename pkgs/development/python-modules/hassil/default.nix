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
  version = "3.12.1";
in
buildPythonPackage rec {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OHF-Voice";
    repo = "hassil";
    tag = "v${version}";
    hash = "sha256-jbodtdsEBDL4nB8kBkPjxFsMOMvsGPDpfMokMRF4xIA=";
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
