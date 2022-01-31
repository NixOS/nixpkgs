{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, fetchpatch
, meson
, ninja
, pkg-config
, vala
, libgee
, granite
, gtk3
, cups
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-printers";
  version = "2.1.10";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0frvybbx7mcs87kww0if4zn0c6c2gb400cpiqrl8b0294py58xpb";
  };

  patches = [
    # Upstream code not respecting our localedir
    # https://github.com/elementary/switchboard-plug-printers/pull/153
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-printers/commit/3e2b01378cbb8e666d23daeef7f40fcaa90daa45.patch";
      sha256 = "0b8pq525xnir06pn65rcz68bcp5xdxl0gpbj7p5x1hs23p5dp04n";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    cups
    granite
    gtk3
    libgee
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Switchboard Printers Plug";
    homepage = "https://github.com/elementary/switchboard-plug-printers";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };

}
