{ lib, stdenv
, fetchFromGitHub
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
, pantheon
, python3
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-notifications";
  version = "6.0.0";

  repoName = "notifications";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "0jfppafbc8jwhhnillylicz4zfds789d8b31ifsx0qijlxa7kji9";
  };

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

  meta = with lib; {
    description = "GTK notification server for Pantheon";
    homepage = "https://github.com/elementary/notifications";
    license = licenses.gpl3Plus;
    maintainers = teams.pantheon.members;
    platforms = platforms.linux;
    mainProgram = "io.elementary.notifications";
  };
}
