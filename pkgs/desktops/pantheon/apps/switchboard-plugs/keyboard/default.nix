{ stdenv
, fetchFromGitHub
, pantheon
, fetchpatch
, substituteAll
, meson
, ninja
, pkgconfig
, vala
, libgee
, granite
, gtk3
, libxml2
, libgnomekbd
, libxklavier
, xorg
, switchboard
}:

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
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
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
    # Fix build with latest vala.
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-keyboard/commit/28fa960f607f0b1d67f2864965a079bdfc23e3a8.patch";
      sha256 = "0121qcg8n7gkz7gpwrxc1cx0nnypj02zy2jmp3cks5r9sc0yi0hw";
    })
  ];

  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "${placeholder "out"}/lib/switchboard";

  meta = with stdenv.lib; {
    description = "Switchboard Keyboard Plug";
    homepage = https://github.com/elementary/switchboard-plug-keyboard;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
