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
, elementary-icon-theme
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-session";
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0lqh9g6qq09m744gncspm79lbwx1vjl1d6j2szwcq9f0jdm01pm5";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
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
    accountsservice
    elementary-icon-theme
    granite
    gtk3
    libgee
    wingpanel
  ];

  PKG_CONFIG_WINGPANEL_2_0_INDICATORSDIR = "${placeholder "out"}/lib/wingpanel";

  meta = with stdenv.lib; {
    description = "Session Indicator for Wingpanel";
    homepage = https://github.com/elementary/wingpanel-indicator-session;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
