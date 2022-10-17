{ lib
, stdenv
, nix-update-script
, appstream
, dbus
, fetchFromGitHub
, flatpak
, glib
, granite
, gtk3
, json-glib
, libgee
, libhandy
, libsoup
, libxml2
, meson
, ninja
, packagekit
, pkg-config
, python3
, vala
, polkit
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "appcenter";
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-Y3ueicw6Hn6lw24hdPeJohGol6l7UlQFIefYsBVY6Hg=";
  };

  nativeBuildInputs = [
    dbus # for pkg-config
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    appstream
    flatpak
    glib
    granite
    gtk3
    json-glib
    libgee
    libhandy
    libsoup
    libxml2
    packagekit
    polkit
  ];

  mesonFlags = [
    "-Dpayments=false"
    "-Dcurated=false"
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/elementary/appcenter";
    description = "An open, pay-what-you-want app store for indie developers, designed for elementary OS";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.appcenter";
  };
}
