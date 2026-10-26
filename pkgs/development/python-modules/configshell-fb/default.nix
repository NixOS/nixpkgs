{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  hatch-vcs,
  pyparsing,
}:

buildPythonPackage (finalAttrs: {
  pname = "configshell-fb";
  version = "2.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "configshell-fb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q/Tx/9BBnxW6busbrigeesxNa5NvBgfKYDNeDquDTOc=";
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
    changelog = "https://github.com/open-iscsi/configshell-fb/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
