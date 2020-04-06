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
, libgee
, libwnck3
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
    granite
    gtk3
    libgee
    libwnck3
    wingpanel
  ];

  meta = with stdenv.lib; {
    description = "Notifications Indicator for Wingpanel";
    homepage = https://github.com/elementary/wingpanel-indicator-notifications;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
