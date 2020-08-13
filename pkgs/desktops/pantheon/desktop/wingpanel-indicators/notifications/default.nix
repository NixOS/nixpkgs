{ stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, pkgconfig
, fetchpatch
, meson
, ninja
, vala
, gtk3
, granite
, wingpanel
, libgee
, elementary-notifications
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-notifications";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0qp13iaf2956ss4d6w6vwnzdvb7izqmyh6xrdii7j8gxxwjd4lxm";
  };

  patches = [
    # Fix do not disturb on NixOS
    # https://github.com/elementary/wingpanel-indicator-notifications/pull/110
    (fetchpatch {
      url = "https://github.com/elementary/wingpanel-indicator-notifications/commit/02b1e226c0262c1535fdf2b4f1daba6be9084f67.patch";
      sha256 = "1a5phygygndr28yx8yp0lyk0wxypc5656dpidw1z8x1yd6xysqhy";
    })
  ];

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
    elementary-notifications
    granite
    gtk3
    libgee
    wingpanel
  ];

  meta = with stdenv.lib; {
    description = "Notifications Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-notifications";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
