{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pkg-config
, meson
, ninja
, vala
, libxml2
, desktop-file-utils
, gtk3
, glib
, granite
, libgee
, libhandy
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-shortcut-overlay";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "shortcut-overlay";
    rev = version;
    sha256 = "sha256-qmqzGCM3cVM6y80pzjm5CCyG6BO6XlKZiODAAEnwVrM=";
  };

  patches = [
    # Fix build with meson 0.61
    # https://github.com/elementary/shortcut-overlay/pull/113
    (fetchpatch {
      url = "https://github.com/elementary/shortcut-overlay/commit/130f78eb4b7770586ea98ba0a5fdbbf5bb116f3f.patch";
      sha256 = "sha256-XXWq9CEv3Z2B8ogcFQAJZCfy19XxNHs3c8NToE2m/aA=";
    })
  ];

  nativeBuildInputs = [
    desktop-file-utils
    libxml2
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    granite
    gtk3
    libgee
    libhandy
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A native OS-wide shortcut overlay to be launched by Gala";
    homepage = "https://github.com/elementary/shortcut-overlay";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.shortcut-overlay";
  };
}
