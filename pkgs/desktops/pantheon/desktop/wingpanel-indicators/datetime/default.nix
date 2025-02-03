{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, substituteAll
, pkg-config
, meson
, python3
, ninja
, vala
, gtk3
, granite
, wingpanel
, evolution-data-server
, libical
, libgee
, libhandy
, libxml2
, libsoup
, libgdata
, elementary-calendar
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-datetime";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-5hg0TH12bEeEPhUUmZz7vS4YTB6t779CXyOCf0c4/X4=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      elementary_calendar = elementary-calendar;
    })
  ];

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkg-config
    python3
    vala
  ];

  buildInputs = [
    evolution-data-server
    granite
    gtk3
    libgee
    libhandy
    libical
    libsoup
    wingpanel
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Date & Time Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-datetime";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
