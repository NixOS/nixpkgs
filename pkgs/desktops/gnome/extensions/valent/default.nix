{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-valent";
  version = "unstable-2023-11-10";

  src = fetchFromGitHub {
    owner = "andyholmes";
    repo = "gnome-shell-extension-valent";
    rev = "c0fad083db3c23382efca623488834054bbbd5cd";
    hash = "sha256-H0EjR7sYK0mepT59PoHgecbk4ksQN8Vyisf6Y+2vT8g=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  passthru = {
    extensionUuid = "valent@andyholmes.ca";
    extensionPortalSlug = "valent";
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
