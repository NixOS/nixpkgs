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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1yybblprcn0cgcf9j76yckqcimm4h8l41cczxjvgp789p1pki3bn";
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
