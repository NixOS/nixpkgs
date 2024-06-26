{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  meson,
  python3,
  ninja,
  vala,
  gtk3,
  glib,
  granite,
  libnotify,
  wingpanel,
  libgee,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-bluetooth";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-VLW3r5X0AWhNRQpajYmCNMIl/UvZCWz14gpxZLlLJdQ=";
  };

  nativeBuildInputs = [
    glib # for glib-compile-schemas
    libxml2
    meson
    ninja
    pkg-config
    python3
    vala
  ];

  buildInputs = [
    glib
    granite
    gtk3
    libgee
    libnotify
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
    description = "Bluetooth Indicator for Wingpanel";
    mainProgram = "io.elementary.bluetooth";
    homepage = "https://github.com/elementary/wingpanel-indicator-bluetooth";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
