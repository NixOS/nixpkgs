{ stdenv
, substituteAll
, fetchFromGitHub
, pantheon
, meson
, ninja
, pkgconfig
, vala
, libgee
, granite
, gtk3
, switchboard
, onboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-a11y";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0g8lhdwv9g16kjn7yxnl6x4rscjl2206ljfnghpxc4b5lwhqxxnw";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit onboard;
    })
  ];

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
    granite
    gtk3
    libgee
    switchboard
  ];

  meta = with stdenv.lib; {
    description = "Switchboard Universal Access Plug";
    homepage = https://github.com/elementary/switchboard-plug-a11y;
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
