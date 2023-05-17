{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, libgee
, granite
, gtk3
, bluez
, switchboard
, wingpanel-indicator-bluetooth
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-bluetooth";
  version = "2.3.6";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0n9fhi9g0ww341bjk6lpc5ppnl7qj9b3d63j9a7iqnap57bgks9y";
  };

  patches = [
    # Upstream code not respecting our localedir
    # https://github.com/elementary/switchboard-plug-bluetooth/pull/182
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-bluetooth/commit/031dd5660b4bcb0bb4e82ebe6d8bcdaa1791c385.patch";
      sha256 = "1g01ad6md7pqp1fx00avbra8yfnr8ipg8y6zhfg35fgjakj4aags";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    bluez
    granite
    gtk3
    libgee
    switchboard
    wingpanel-indicator-bluetooth # settings schema
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Bluetooth Plug";
    homepage = "https://github.com/elementary/switchboard-plug-bluetooth";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };

}
