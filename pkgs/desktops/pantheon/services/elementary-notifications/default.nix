{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, gtk3
, glib
, granite
, libgee
, libhandy
, libcanberra-gtk3
, python3
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-notifications";
  version = "6.0.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "notifications";
    rev = version;
    sha256 = "sha256-B1wo1N4heG872klFJOBKOEds0+6aqtvkTGefi97bdU8=";
  };

  patches = [
    # Backports https://github.com/elementary/notifications/pull/184
    # Needed for https://github.com/elementary/wingpanel-indicator-notifications/pull/252
    # Should be part of next bump
    (fetchpatch {
      url = "https://github.com/elementary/notifications/commit/bd159979dbe3dbe6f3f1da7acd8e0721cc20ef80.patch";
      sha256 = "sha256-cOfeXwoMVgvbA29axyN7HtYKTgCtGxAPrB2PA/x8RKY=";
    })
  ];

  nativeBuildInputs = [
    glib # for glib-compile-schemas
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    granite
    gtk3
    libcanberra-gtk3
    libgee
    libhandy
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "GTK notification server for Pantheon";
    homepage = "https://github.com/elementary/notifications";
    license = licenses.gpl3Plus;
    maintainers = teams.pantheon.members;
    platforms = platforms.linux;
    mainProgram = "io.elementary.notifications";
  };
}
