{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, substituteAll
, pantheon
, meson
, ninja
, pkg-config
, vala
, libgee
, libxml2
, granite
, gtk3
, switchboard
, gnome-settings-daemon
, glib
, gala # needed for gestures support
, touchegg
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-mouse-touchpad";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "19kiwrdpan8hr5r79y591591qjx7pm3x814xfkg9vi11ndbcrznr";
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
    gala
    glib
    granite
    gtk3
    libgee
    libxml2
    gnome-settings-daemon
    switchboard
    touchegg
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      touchegg = touchegg;
    })
    # Upstream code not respecting our localedir
    # https://github.com/elementary/switchboard-plug-mouse-touchpad/pull/185
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-mouse-touchpad/commit/a6f84dc08be5dc6f7535082bacfa24e2dff4ef67.patch";
      sha256 = "0fxl894dzw1f84n36mb9y7gshs69xcb0samvs2gsa0pcdlzfp3cy";
    })
  ];

  meta = with lib; {
    description = "Switchboard Mouse & Touchpad Plug";
    homepage = "https://github.com/elementary/switchboard-plug-mouse-touchpad";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
