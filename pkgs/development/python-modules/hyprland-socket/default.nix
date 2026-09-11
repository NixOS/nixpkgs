{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "hyprland-socket";
  version = "0.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BlueManCZ";
    repo = "hyprland-socket";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XPVhHnIwq4Plkuk3uf/IUcg9L0OsZT76cr60x7EG1lc=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hyprland_socket" ];

  meta = {
    description = "Typed Python library for Hyprland IPC via Unix sockets";
    homepage = "https://github.com/BlueManCZ/hyprland-socket";
    changelog = "https://github.com/BlueManCZ/hyprland-socket/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sophronesis ];
  };
})
