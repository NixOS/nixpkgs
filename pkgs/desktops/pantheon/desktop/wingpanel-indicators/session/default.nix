{ stdenv, fetchFromGitHub, pantheon, pkgconfig, meson
, ninja, vala, gtk3, granite, wingpanel, accountsservice
, libgee, gobject-introspection, elementary-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-session";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1y0blff02p3w23sv17yg7fq0yq0g2k8j7vjmk92k664fx72kjjzh";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
    };
  };

  nativeBuildInputs = [
    gobject-introspection
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
