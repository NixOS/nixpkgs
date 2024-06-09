{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, substituteAll
, meson
, ninja
, pkg-config
, vala
, libadwaita
, libgee
, gnome-settings-daemon
, granite7
, gsettings-desktop-schemas
, gtk4
, libxml2
, libgnomekbd
, libxklavier
, ibus
, onboard
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-keyboard";
  version = "3.2.1-unstable-2024-05-16";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "1b37c6b2bf6c17ceb21e0a48f0763dbe36751a84";
    sha256 = "sha256-/TMmWhgjloeKLfbvLnbeAugPXBKXDB74UQpbYplYVdc=";
  };

  patches = [
    # This will try to install packages with apt.
    # https://github.com/elementary/switchboard-plug-keyboard/issues/324
    ./hide-install-unlisted-engines-button.patch

    (substituteAll {
      src = ./fix-paths.patch;
      inherit onboard libgnomekbd;
    })
  ];

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    gnome-settings-daemon # media-keys
    granite7
    gsettings-desktop-schemas
    gtk4
    ibus
    libadwaita
    libgee
    libxklavier
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Keyboard Plug";
    homepage = "https://github.com/elementary/switchboard-plug-keyboard";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
