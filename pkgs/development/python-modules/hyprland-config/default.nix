{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "hyprland-config";
  version = "0.9.6";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BlueManCZ";
    repo = "hyprland-config";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c+2eZyDdFTmcqqiESjjo6PPN2G4uGpp66UtGBlDiV2M=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hyprland_config" ];

  # tests try to collect from removed test dir
  doCheck = false;

  meta = {
    description = "Round-trip parser and editor for Hyprland configuration files";
    homepage = "https://github.com/BlueManCZ/hyprland-config";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sophronesis ];
  };
})
