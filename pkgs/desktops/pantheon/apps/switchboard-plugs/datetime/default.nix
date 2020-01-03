{ stdenv
, fetchFromGitHub
, pantheon
, meson
, ninja
, substituteAll
, pkgconfig
, vala
, libgee
, granite
, gtk3
, libxml2
, switchboard
, tzdata
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-datetime";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "09734c3qc0296zf14rdhl4p6ppga015rz9hhsvlcc3nvyw7kdqkc";
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
    switchboard
  ];

  patches = [
    (substituteAll {
      src = ./timezone.patch;
      tzdata = "${tzdata}/share/zoneinfo/zone.tab";
    })
  ];

  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "${placeholder "out"}/lib/switchboard";

  meta = with stdenv.lib; {
    description = "Switchboard Date & Time Plug";
    homepage = https://github.com/elementary/switchboard-plug-datetime;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
