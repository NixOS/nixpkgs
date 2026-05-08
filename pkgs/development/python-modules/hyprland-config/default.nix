{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "hyprland-config";
  version = "0.4.5";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BlueManCZ";
    repo = "hyprland-config";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C0EvNNSg91vC7/LPt4WkgJA2y54K3XQppWVe4JNL6Go=";
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
