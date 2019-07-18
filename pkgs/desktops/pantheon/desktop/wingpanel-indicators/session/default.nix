{ stdenv, fetchFromGitHub, pantheon, pkgconfig, meson
, ninja, vala, gtk3, granite, wingpanel, accountsservice
, libgee, elementary-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-session";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1x2p2sjal42bspmqcg9lzixv6rnihvgmwk92gfcccrmvk8j4bx6s";
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

  PKG_CONFIG_WINGPANEL_2_0_INDICATORSDIR = "${placeholder ''out''}/lib/wingpanel";

  meta = with stdenv.lib; {
    description = "Session Indicator for Wingpanel";
    homepage = https://github.com/elementary/wingpanel-indicator-session;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
