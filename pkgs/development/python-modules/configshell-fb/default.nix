{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  hatchling,
  hatch-vcs,
  pyparsing,
}:

buildPythonPackage rec {
  pname = "configshell-fb";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "configshell-fb";
    tag = "v${version}";
    hash = "sha256-lP3WT9ASEj6WiCrurSU/e9FhIaeoQW/n9hi1XZMnV4Q=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    pyparsing
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "configshell" ];

  meta = {
    description = "Python library for building configuration shells";
    homepage = "https://github.com/open-iscsi/configshell-fb";
    changelog = "https://github.com/open-iscsi/configshell-fb/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
