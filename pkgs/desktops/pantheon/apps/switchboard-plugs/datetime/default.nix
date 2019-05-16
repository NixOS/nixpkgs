{ stdenv, fetchFromGitHub, pantheon, meson, ninja, substituteAll, pkgconfig
, vala, libgee, granite, gtk3, libxml2, switchboard, tzdata, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-datetime";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1iz8skf5dw76a07ljc8v8lw2x2nrmq8j6sggm227cmxy60gadsdv";
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
    switchboard
  ];

  patches = [
    (substituteAll {
      src = ./timezone.patch;
      tzdata = "${tzdata}/share/zoneinfo/zone.tab";
    })
    # Use "clock-format" GSettings key that's been moved to granite
    ./clock-format.patch
  ];

  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "${placeholder ''out''}/lib/switchboard";

  meta = with stdenv.lib; {
    description = "Switchboard Date & Time Plug";
    homepage = https://github.com/elementary/switchboard-plug-datetime;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
