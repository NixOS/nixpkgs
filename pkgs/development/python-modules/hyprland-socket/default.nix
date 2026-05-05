{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hyprland-socket";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BlueManCZ";
    repo = "hyprland-socket";
    tag = "v${version}";
    hash = "sha256-yyNgNupKtQdW045GWcLgmZWr06BRSdF4HouN0rf++iI=";
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
}
