{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hyprland-config";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BlueManCZ";
    repo = "hyprland-config";
    tag = "v${version}";
    hash = "sha256-c47+ZnXsIwg+k9XLK9in76x4PCbsSxZ6+UShb1tfvyY=";
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
}
