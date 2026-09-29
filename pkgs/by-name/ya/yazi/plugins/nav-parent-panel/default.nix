{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "nav-parent-panel";
  version = "0-unstable-2025-09-15";

  src = fetchFromGitHub {
    owner = "yaqihou";
    repo = "nav-parent-panel.yazi";
    rev = "e72b944cf58d227a80bbd816031068870b20178f";
    hash = "sha256-jKCCggyldQrdw88DaNXNuLbEq88HgoWc0oCCWTtQF2g=";
  };

  meta = {
    description = "Yazi plugin to navigate between sibling directories";
    longDescription = ''
      This plugin allows you to cycle through sibling directories (same level
      as the current directory) without having to go up to the parent directory.

      For a visual demonstration, check
      [this example](https://github.com/yaqihou/nav-parent-panel.yazi#example).
    '';
    homepage = "https://github.com/yaqihou/nav-parent-panel.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
  };
}
