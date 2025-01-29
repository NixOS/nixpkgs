{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-valent";
  version = "1.0.0.alpha.46";

  src = fetchFromGitHub {
    owner = "andyholmes";
    repo = "gnome-shell-extension-valent";
    rev = "v${version}";
    hash = "sha256-OY0fxO6IYg7xukYYuK0QM9YriaEAlM2dH6t8Wv3XKIs=";
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
