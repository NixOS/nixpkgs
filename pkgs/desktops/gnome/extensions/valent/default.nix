{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-valent";
  version = "0-unstable-2024-05-12";

  src = fetchFromGitHub {
    owner = "andyholmes";
    repo = "gnome-shell-extension-valent";
    rev = "9998f737de3d538b26b085871739e2f3de9e3d0f";
    hash = "sha256-lDAHPThhSacju9LltsM11gSfj0nYfpj0S19iu+wA/98=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  passthru = {
    extensionUuid = "valent@andyholmes.ca";
    extensionPortalSlug = "valent";
    updateScript = unstableGitUpdater { };
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
