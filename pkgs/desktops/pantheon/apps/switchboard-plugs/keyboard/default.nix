{ stdenv, fetchFromGitHub, pantheon, substituteAll, meson, ninja, pkgconfig, vala, libgee
, granite, gtk3, libxml2, libgnomekbd, libxklavier, xorg, switchboard, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-keyboard";
  version = "2.3.5";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "17iijb7imxw5zv7vkrbc1vsp87k900yqgyv7ycz1gw37xb4klsyp";
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

  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "${placeholder ''out''}/lib/switchboard";

  meta = with stdenv.lib; {
    description = "Switchboard Keyboard Plug";
    homepage = https://github.com/elementary/switchboard-plug-keyboard;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
