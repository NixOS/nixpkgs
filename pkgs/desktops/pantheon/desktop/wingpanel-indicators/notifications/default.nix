{ stdenv, fetchFromGitHub, pantheon, pkgconfig, meson, ninja, vala, gtk3, granite
, wingpanel, libgee, libwnck3, gobject-introspection, elementary-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-notifications";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1960s3xcsx6yjlnk0csf1m66s1z1sj5rym9b2fy7pm2nan47z3ld";
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
    elementary-icon-theme
    granite
    gtk3
    libgee
    libwnck3
    wingpanel
  ];

  PKG_CONFIG_WINGPANEL_2_0_INDICATORSDIR = "lib/wingpanel";

  meta = with stdenv.lib; {
    description = "Notifications Indicator for Wingpanel";
    homepage = https://github.com/elementary/wingpanel-indicator-notifications;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
