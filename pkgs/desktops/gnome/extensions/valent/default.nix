{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-valent";
  version = "1.0.0.alpha.49";

  src = fetchFromGitHub {
    owner = "andyholmes";
    repo = "gnome-shell-extension-valent";
    tag = "v${version}";
    hash = "sha256-yfi/69RRmXf1zJPIDXp9/F8YgeJ5fgGX43dJS4hwp+s=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  passthru = {
    extensionUuid = "valent@andyholmes.ca";
    extensionPortalSlug = "valent";
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
  };

  meta = {
    description = "GNOME Shell integration for Valent";
    homepage = "https://valent.andyholmes.ca/";
    changelog = "https://github.com/andyholmes/gnome-shell-extension-valent/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
