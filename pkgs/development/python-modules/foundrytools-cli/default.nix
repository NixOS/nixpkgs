{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # dependencies
  afdko,
  click,
  foundrytools,
  loguru,
  pathvalidate,
  rich,
  ufolib2,
}:
buildPythonPackage (finalAttrs: {
  pname = "foundrytools-cli";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ftCLI";
    repo = "FoundryTools-CLI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KYCiFs5IJwE+OGxQ+UcOSzjd3noeO21OVXtPpsyLfFU=";
  };

  build-system = [
    uv-build
  ];

  dependencies = [
    afdko
    click
    foundrytools
    loguru
    pathvalidate
    rich
    ufolib2
  ];

  meta = {
    description = "Command line interface for the FoundryTools library";
    homepage = "https://github.com/ftCLI/FoundryTools-CLI";
    changelog = "https://github.com/ftCLI/FoundryTools-CLI/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pengo ];
  };
})
