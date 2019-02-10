{ stdenv, fetchFromGitHub, pantheon, substituteAll, meson, ninja, pkgconfig, vala, libgee
, granite, gtk3, libxml2, libgnomekbd, libxklavier, xorg, switchboard, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-keyboard";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1997hnhlcp2jmf3z70na42vl1b7i5vxhp7k5ga5sl68dv0g4126y";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
    };
  };

  nativeBuildInputs = [
    gobject-introspection
    libxml2
    meson
    ninja
    pkgconfig
    vala
  ];

  buildInputs = [
    granite
    gtk3
    libgee
    libgnomekbd
    libxklavier
    switchboard
  ];

  patches = [
    (substituteAll {
      src = ./xkb.patch;
      config = "${xorg.xkeyboardconfig}/share/X11/xkb/rules/evdev.xml";
    })
  ];

  LIBRARY_PATH = stdenv.lib.makeLibraryPath [ libgnomekbd ];

  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "lib/switchboard";

  meta = with stdenv.lib; {
    description = "Switchboard Keyboard Plug";
    homepage = https://github.com/elementary/switchboard-plug-keyboard;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
