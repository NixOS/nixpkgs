{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-valent";
  version = "unstable-2023-03-18";

  src = fetchFromGitHub {
    owner = "andyholmes";
    repo = "gnome-shell-extension-valent";
    rev = "e7f759047c45833cd211ef18a8554008cb1b8b12";
    hash = "sha256-ylCyQbFbzCuSM2YrLuI36eXL2qQjTt1mYewJlCywKvI=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  passthru = {
    extensionUuid = "valent@andyholmes.ca";
    extensionPortalSlug = "valent";
  };

  meta = with lib; {
    description = "GNOME Shell integration for Valent";
    homepage = "https://valent.andyholmes.ca/";
    changelog = "https://github.com/andyholmes/gnome-shell-extension-valent/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.federicoschonborn ];
    platforms = platforms.linux;
  };
}
