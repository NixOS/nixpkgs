{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pkg-config
, meson
, python3
, ninja
, vala
, gnome-settings-daemon
, gtk3
, granite
, wingpanel
, libnotify
, pulseaudio
, libcanberra-gtk3
, libgee
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-sound";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-gQyL8g4Y5kM9/1EDLAQYiTSZ6CxuvfQv7LBRZNcGPVk=";
  };

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkg-config
    python3
    vala
  ];

  buildInputs = [
    gnome-settings-daemon # media-keys
    granite
    gtk3
    libcanberra-gtk3
    libgee
    libnotify
    pulseaudio
    wingpanel
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Sound Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-sound";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
