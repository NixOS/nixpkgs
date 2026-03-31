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

buildPythonPackage rec {
  pname = "hyprland-state";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BlueManCZ";
    repo = "hyprland-state";
    tag = "v${version}";
    hash = "sha256-cNuCSw+PExL6CVFlnXXj1URN4J2ZKWYlWLV+vbviM2I=";
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
}
