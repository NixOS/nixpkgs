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

buildPythonPackage rec {
  pname = "hassil";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "hassil";
    tag = "v${version}";
    hash = "sha256-A0cvWMzEgrfhVA34tCmlt/LBmJbJ7+uR+B1ump0XQFQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
    unicode-rbnf
  ];

  pythonImportsCheck = [ "hassil" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    changelog = "https://github.com/home-assistant/hassil/blob/${src.tag}/CHANGELOG.md";
    description = "Intent parsing for Home Assistant";
    mainProgram = "hassil";
    homepage = "https://github.com/home-assistant/hassil";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
  };
}
