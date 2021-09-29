{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, meson
, ninja
, pkg-config
, vala
, libgee
, granite
, gtk3
, libaccounts-glib
, libgdata
, libhandy
, libsignon-glib
, json-glib
, librest
, webkitgtk
, libsoup
, sqlite
, switchboard
, evolution-data-server
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-onlineaccounts";
  version = "6.2.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1q3f7zr04p2100mb255zy38il2i47l6vqdc9a9acjbk3n7q5sf92";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    evolution-data-server
    granite
    gtk3
    json-glib
    libaccounts-glib
    libgdata
    libgee
    libhandy
    libsignon-glib
    libsoup
    librest
    sqlite # needed for camel-1.2
    switchboard
    webkitgtk
  ];

  PKG_CONFIG_LIBACCOUNTS_GLIB_PROVIDERFILESDIR = "${placeholder "out"}/share/accounts/providers";
  PKG_CONFIG_LIBACCOUNTS_GLIB_SERVICEFILESDIR = "${placeholder "out"}/share/accounts/services";

  meta = with lib; {
    description = "Switchboard Online Accounts Plug";
    homepage = "https://github.com/elementary/switchboard-plug-onlineaccounts";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };

}
