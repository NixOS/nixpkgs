{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  python3,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "xapp-symbolic-icons";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "xapp-project";
    repo = "xapp-symbolic-icons";
    tag = finalAttrs.version;
    hash = "sha256-lzxNtalNNKTamoToHWXkqWUoPqQZiWvgETVqLF1ov8Q=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  buildInputs = [
    python3 # xsi-replace-adwaita-symbolic
  ];

  meta = {
    homepage = "https://github.com/xapp-project/xapp-symbolic-icons";
    description = "Set of symbolic icons for GTK applications and projects";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
})
