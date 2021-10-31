{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, substituteAll
, pantheon
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
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-/kbwZVzOlC3ATCuXVMdf2RIskoGQKG1evaDYO3yFerg=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      elementary_calendar = elementary-calendar;
    })
    # Fix incorrect month shown on re-opening indicator if previously changed month
    # https://github.com/elementary/wingpanel-indicator-datetime/pull/284
    ./fix-incorrect-month.patch
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
    libgdata # required by some dependency transitively
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Date & Time Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-datetime";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
