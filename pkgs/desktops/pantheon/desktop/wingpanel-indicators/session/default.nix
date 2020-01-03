{ stdenv
, fetchFromGitHub
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
  version = "2.2.6";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0pzknbm0hg4kf2izfg1mcmyildfzwyq1hh0xhlq16gsmakq4ld26";
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
    accountsservice
    granite
    gtk3
    libgee
    wingpanel
  ];

  meta = with stdenv.lib; {
    description = "Session Indicator for Wingpanel";
    homepage = https://github.com/elementary/wingpanel-indicator-session;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
