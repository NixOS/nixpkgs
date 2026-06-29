{
  buildPythonPackage,
  cryptography,
  fetchPypi,
  hatch-vcs,
  hatchling,
  lib,
  prettytable,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "psptool";
  version = "3.6";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ULSSN48sIWxkvhL9afcwAHdOarBa4jJOowNaxz5kwbQ=";
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
    license = lib.licenses.gpl3;
    mainProgram = "psptool";
    maintainers = with lib.maintainers; [
      nmetschke
    ];
  };
})
