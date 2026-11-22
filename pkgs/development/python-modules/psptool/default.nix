{
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  lib,
  prettytable,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "psptool";
  version = "3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PSPReverse";
    repo = "PSPTool";
    tag = finalAttrs.version;
    hash = "sha256-S5pBgaHlepyq0xqwO+LSBqbihN9DSnyxEhrkPaL4BDE=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    cryptography
    prettytable
  ];

  pythonImportChecks = [ "psptool.PSPTool" ];

  nativeCheckInputs = [
    pytestCheckHook
    versionCheckHook
  ];

  # needed for cli test
  preCheck = ''
    export PATH="$PATH:$out/bin"
  '';

  disabledTestPaths = [
    # the integration test require ROM files from a private submodule
    "tests/integration"
  ];

  meta = {
    description = "PSPTool is a tool for dealing with AMD binary blobs";
    homepage = "https://github.com/PSPReverse/PSPTool";
    license = lib.licenses.gpl3Plus;
    mainProgram = "psptool";
    maintainers = with lib.maintainers; [
      nmetschke
    ];
  };
})
