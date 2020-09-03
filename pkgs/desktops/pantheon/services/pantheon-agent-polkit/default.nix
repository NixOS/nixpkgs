{ stdenv
, fetchFromGitHub
, pantheon
, pkgconfig
, meson
, ninja
, vala
, gtk3
, libgee
, granite
, polkit
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "pantheon-agent-polkit";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-YL1LHnPH7pP0EW9IkjdSEX+VuaAF9uNyFbl47vjVps0=";
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
    wrapGAppsHook
  ];

  buildInputs = [
    granite
    gtk3
    libgee
    polkit
  ];

  meta = with stdenv.lib; {
    description = "Polkit Agent for the Pantheon Desktop";
    homepage = https://github.com/elementary/pantheon-agent-polkit;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
