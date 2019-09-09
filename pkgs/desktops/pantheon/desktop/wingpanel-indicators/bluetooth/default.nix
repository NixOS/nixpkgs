{ stdenv
, fetchFromGitHub
, pantheon
, pkgconfig
, meson
, python3
, ninja
, vala
, gtk3
, granite
, libnotify
, wingpanel
, libgee
, libxml2
, elementary-icon-theme
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-bluetooth";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "04ggakf7qp4q0kah5xksbwjn78wpdrp9kdgkj6ibzsb97ngn70g9";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
    };
  };

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    elementary-icon-theme
    granite
    gtk3
    libgee
    libnotify
    wingpanel
  ];

  PKG_CONFIG_WINGPANEL_2_0_INDICATORSDIR = "${placeholder "out"}/lib/wingpanel";

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Bluetooth Indicator for Wingpanel";
    homepage = https://github.com/elementary/wingpanel-indicator-bluetooth;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
