{ stdenv, fetchFromGitHub, pantheon, meson, ninja, pkgconfig, vala
, libgee, granite, gtk3, libaccounts-glib, libsignon-glib, json-glib
, librest, webkitgtk, libsoup, switchboard, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-onlineaccounts";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "03h8ii8zz59fpp4fwlvyx3m3550096fn7a6w612b1rbj3dqhlmh9";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
    };
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkgconfig
    vala
  ];

  buildInputs = [
    granite
    gtk3
    json-glib
    libaccounts-glib
    libgee
    libsignon-glib
    libsoup
    librest
    switchboard
    webkitgtk
  ];

  PKG_CONFIG_LIBACCOUNTS_GLIB_PROVIDERFILESDIR = "${placeholder "out"}/share/accounts/providers";
  PKG_CONFIG_LIBACCOUNTS_GLIB_SERVICEFILESDIR = "${placeholder "out"}/share/accounts/services";
  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "${placeholder "out"}/lib/switchboard";


  meta = with stdenv.lib; {
    description = "Switchboard Online Accounts Plug";
    homepage = https://github.com/elementary/switchboard-plug-onlineaccounts;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };

}
