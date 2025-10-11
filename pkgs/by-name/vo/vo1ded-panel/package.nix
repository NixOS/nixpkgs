{
  lib,
  ags,
  astal,
  fetchFromGitHub,
}:
ags.bundle {
  pname = "vo1ded-panel";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Vo1dSh4d0w";
    repo = "vo1ded-panel";
    rev = "3fabccbb55836a6779ce3b690214c26c5720bda4";
    hash = "sha256-9A/hK1iS11No6kqwnOsz9w5/9k5i/rCQ9299YI8V9SE=";
  };

  strictDeps = true;
  dependencies = [
    astal.hyprland
    astal.tray
    astal.wireplumber
  ];

  meta = {
    homepage = "https://github.com/Vo1dSh4d0w/vo1ded-panel";
    description = "Simple shell for Hyprland made with ags";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vo1dsh4d0w ];
    mainProgram = "vo1ded-panel";
    platforms = lib.platforms.linux;
  };
}
