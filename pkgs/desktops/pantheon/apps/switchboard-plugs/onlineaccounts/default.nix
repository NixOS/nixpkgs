{ stdenv
, fetchFromGitHub
, fetchpatch
, pantheon
, meson
, ninja
, pkgconfig
, vala
, libgee
, granite
, gtk3
, libaccounts-glib
, libsignon-glib
, json-glib
, librest
, webkitgtk
, libsoup
, switchboard
}:

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
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
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

  patches = [
    # Fix build with latest vala
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-onlineaccounts/commit/5fa2882f765076d20c6ef4886198a34a05159f8a.patch";
      sha256 = "1szryyy7shdmbvx9yhpi0bhzaayg7hl6pq2c456j1qf9kfv0m4hf";
    })
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
