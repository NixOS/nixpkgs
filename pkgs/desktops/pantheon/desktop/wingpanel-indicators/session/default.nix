{ stdenv
, fetchFromGitHub
, nix-update-script
, fetchpatch
, pantheon
, pkgconfig
, meson
, ninja
, vala
, gtk3
, granite
, wingpanel
, accountsservice
, libgee
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-session";
  version = "unstable-2020-09-13";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "e65c95f46adbfd598ad61933394d7bc3c5998278";
    sha256 = "sha256-QKOfgAc6pDQYpETrFunZB6+rF1P8XIf0pjft/t9aWW0=";
  };

  passthru = {
    updateScript = nix-update-script {
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
    accountsservice
    granite
    gtk3
    libgee
    wingpanel
  ];

  meta = with stdenv.lib; {
    description = "Session Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-session";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
