{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hyprland-config,
  hyprland-monitors,
  hyprland-schema,
  hyprland-socket,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "hyprland-state";
  version = "0.4.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BlueManCZ";
    repo = "hyprland-state";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HvkVFFPh5mDNcOMRpKjznoCN7Q77DL6LZ9BhPGHs0PI=";
  };

  build-system = [ hatchling ];

  dependencies = [
    hyprland-config
    hyprland-monitors
    hyprland-schema
    hyprland-socket
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hyprland_state" ];

  # tests require running Hyprland instance
  doCheck = false;

  meta = {
    description = "Live state interface for Hyprland - options, animations, monitors, binds, and devices";
    homepage = "https://github.com/BlueManCZ/hyprland-state";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sophronesis ];
  };
})
