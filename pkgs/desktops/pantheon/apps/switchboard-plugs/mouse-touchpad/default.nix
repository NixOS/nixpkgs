{ stdenv, fetchFromGitHub, pantheon, fetchpatch, meson, ninja
, pkgconfig, vala, libgee, granite, gtk3, switchboard, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-mouse-touchpad";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1zh5472ab01bckrc1py5bqqsal9i9pbgx6i8ap2d4yzhc8sirjrf";
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
    libgee
    switchboard
  ];

  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "lib/switchboard";

  meta = with stdenv.lib; {
    description = "Switchboard Mouse & Touchpad Plug";
    homepage = https://github.com/elementary/switchboard-plug-mouse-touchpad;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
