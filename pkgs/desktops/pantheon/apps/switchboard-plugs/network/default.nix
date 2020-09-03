{ stdenv
, fetchFromGitHub
, pantheon
, meson
, ninja
, pkgconfig
, substituteAll
, vala
, libgee
, granite
, gtk3
, networkmanager
, networkmanagerapplet
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-network";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-PYgewxBblhOfOJQSeRaq8xD7qZ3083EvgUjpi92FqyI=";
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
    granite
    gtk3
    libgee
    networkmanager
    networkmanagerapplet
    switchboard
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit networkmanagerapplet;
    })
  ];


  meta = with stdenv.lib; {
    description = "Switchboard Networking Plug";
    homepage = https://github.com/elementary/switchboard-plug-network;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
