{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

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
  version = "2.0.5";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "hassil";
    tag = "v${version}";
    hash = "sha256-e6Y0GGURGKzbX1dniBbYEJB9K3/R84n3UmnMO0HPPPo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
    unicode-rbnf
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    changelog = "https://github.com/home-assistant/hassil/blob/${version}/CHANGELOG.md";
    description = "Intent parsing for Home Assistant";
    mainProgram = "hassil";
    homepage = "https://github.com/home-assistant/hassil";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
  };
}
