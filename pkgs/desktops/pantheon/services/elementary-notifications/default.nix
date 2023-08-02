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
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "notifications";
    rev = version;
    sha256 = "sha256-i7fSKnP4W12cfax5IXm/Zgy5vP5z7S43S80gvzWpFCE=";
  };

  patches = [
    # Fix broken notification filter
    # https://github.com/elementary/notifications/pull/207
    (fetchpatch {
      url = "https://github.com/elementary/notifications/commit/4691ec869316be94598d8e55e1cd3bd525e8e149.patch";
      sha256 = "sha256-4x/Us92Mgws5v+ZQiKvjQ4ixfBnU8oTQ92rc+nf8Zdg=";
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
