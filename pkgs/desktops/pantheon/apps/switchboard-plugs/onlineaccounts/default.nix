{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, meson
, ninja
, pkg-config
, vala_0_52
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
, switchboard
, evolution-data-server
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-onlineaccounts";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1v4rvmimnzbl9plgkdhzp7hijciwi0pgh6y88zjdhvd969c3wqwx";
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
    vala_0_52
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
    switchboard
    webkitgtk
  ];

  PKG_CONFIG_LIBACCOUNTS_GLIB_PROVIDERFILESDIR = "${placeholder "out"}/share/accounts/providers";
  PKG_CONFIG_LIBACCOUNTS_GLIB_SERVICEFILESDIR = "${placeholder "out"}/share/accounts/services";
  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "${placeholder "out"}/lib/switchboard";


  meta = with lib; {
    description = "Switchboard Online Accounts Plug";
    homepage = "https://github.com/elementary/switchboard-plug-onlineaccounts";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };

}
