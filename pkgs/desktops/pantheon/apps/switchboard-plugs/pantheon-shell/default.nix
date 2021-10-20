{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pantheon
, meson
, ninja
, pkg-config
, vala
, glib
, libgee
, granite
, gexiv2
, gnome-settings-daemon
, elementary-settings-daemon
, gtk3
, gnome-desktop
, gala
, wingpanel
, elementary-dock
, switchboard
, gettext
, bamf
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-pantheon-shell";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0349150kxdv14ald79pzn7lasiqipyc37fgchygbc8hsy62d9a32";
  };

  patches = [
    # Upstream code not respecting our localedir
    # https://github.com/elementary/switchboard-plug-pantheon-shell/pull/286
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-pantheon-shell/commit/0c3207ffaeaa82ca3c743bc9ec772185fbd7e8cf.patch";
      sha256 = "11ymzqx6has4zf8y0xy7pfhymcl128hzzjcgp46inshjf99v5kiv";
    })
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    bamf
    elementary-dock
    elementary-settings-daemon
    gnome-settings-daemon
    gala
    gexiv2
    glib
    gnome-desktop
    granite
    gtk3
    libgee
    switchboard
    wingpanel
  ];

  meta = with lib; {
    description = "Switchboard Desktop Plug";
    homepage = "https://github.com/elementary/switchboard-plug-pantheon-shell";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
