{ lib
, stdenv
, nix-update-script
, appstream
, appstream-glib
, dbus
, desktop-file-utils
, elementary-gtk-theme
, elementary-icon-theme
, fetchFromGitHub
, flatpak
, gettext
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
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-+r19n42FPoBArZNDF4ZAdUBZqsSxpLwpeBoyaRJBCrg=";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    appstream-glib
    dbus # for pkg-config
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    appstream
    elementary-gtk-theme
    elementary-icon-theme
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

  meta = with lib; {
    homepage = "https://github.com/elementary/appcenter";
    description = "An open, pay-what-you-want app store for indie developers, designed for elementary OS";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.appcenter";
  };
}
