{ stdenv, fetchFromGitHub, pantheon, meson, ninja, pkgconfig, vala, libgee
, granite, gtk3, bluez, switchboard, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-bluetooth";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1aynzns0xw629drv9qvci37ba0fzyd5x9y8kwjqr527rnk0qiyca";
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
    bluez
    granite
    gtk3
    libgee
    switchboard
  ];

  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "lib/switchboard";

  meta = with stdenv.lib; {
    description = "Switchboard Bluetooth Plug";
    homepage = https://github.com/elementary/switchboard-plug-bluetooth;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };

}
