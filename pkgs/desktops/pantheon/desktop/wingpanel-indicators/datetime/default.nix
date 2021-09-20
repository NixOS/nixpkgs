{ lib, stdenv
, fetchFromGitHub
, fetchpatch
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
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1mdm0fsnmmyw8c0ik2jmfri3kas9zkz1hskzf8wvbd51vnazfpgw";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

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

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      elementary_calendar = elementary-calendar;
    })
    # Upstream code not respecting our localedir
    # https://github.com/elementary/wingpanel-indicator-datetime/pull/269
    (fetchpatch {
      url = "https://github.com/elementary/wingpanel-indicator-datetime/commit/f7befa68a9fd6215297c334a366919d3431cae65.patch";
      sha256 = "0l997b1pnpjscs886xy28as5yykxamxacvxdv8466zin7zynarfs";
    })
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with lib; {
    description = "Date & Time Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-datetime";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
