{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "hyprland-socket";
  version = "0.12.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BlueManCZ";
    repo = "hyprland-socket";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xZh0re/bfWM0Nwv9bx/EsyE3coJjxhSpRiau/6Bg1Nc=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hyprland_socket" ];

  # tests require running Hyprland instance
  doCheck = false;

  meta = {
    description = "Typed Python library for Hyprland IPC via Unix sockets";
    homepage = "https://github.com/BlueManCZ/hyprland-socket";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sophronesis ];
  };
})
