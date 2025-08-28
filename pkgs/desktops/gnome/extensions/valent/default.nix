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
  version = "1.0.0.alpha.48";

  src = fetchFromGitHub {
    owner = "andyholmes";
    repo = "gnome-shell-extension-valent";
    tag = "v${version}";
    hash = "sha256-j5590Emcga3Wp7/lC/ni2NpEC3bkR2/vT4Cq/m8GvBM=";
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
