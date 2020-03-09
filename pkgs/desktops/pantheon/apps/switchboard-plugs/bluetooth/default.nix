{ stdenv
, fetchFromGitHub
, pantheon
, meson
, ninja
, pkgconfig
, vala
, libgee
, granite
, gtk3
, bluez
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-bluetooth";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "06ws1swl2jg6a1b3m4b1v1rawgzs5k7rq4dcnd5v0czda110yhg0";
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
    bluez
    granite
    gtk3
    libgee
    switchboard
  ];

  meta = with stdenv.lib; {
    description = "Switchboard Bluetooth Plug";
    homepage = https://github.com/elementary/switchboard-plug-bluetooth;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };

}
