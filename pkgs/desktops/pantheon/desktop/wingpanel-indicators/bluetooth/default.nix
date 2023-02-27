{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pkg-config
, meson
, python3
, ninja
, vala
, gtk3
, glib
, granite
, libnotify
, wingpanel
, libgee
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-bluetooth";
  version = "2.1.8";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "12rasf8wy3cqnfjlm9s2qnx4drzx0w0yviagkng3kspdzm3vzsqy";
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
    homepage = "https://github.com/elementary/wingpanel-indicator-bluetooth";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
