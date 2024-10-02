{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pkg-config
, meson
, python3
, ninja
, sassc
, vala
, glib
, gtk4
, libadwaita
, libgee
, granite7
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "switchboard";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-qSqZQcE/g9oOHI8OAxMACSIFXrJMgSFLraAbTHjggLY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    sassc
    vala
    wrapGAppsHook4
  ];

  propagatedBuildInputs = [
    # Required by switchboard-3.pc.
    glib
    granite7
    gtk4
    libadwaita
    libgee
  ];

  patches = [
    ./plugs-path-env.patch
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Extensible System Settings app for Pantheon";
    homepage = "https://github.com/elementary/switchboard";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.settings";
  };
}
