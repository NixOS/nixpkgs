{ stdenv
, fetchFromGitHub
, pantheon
, pkgconfig
, meson
, ninja
, vala
, gtk3
, granite
, networkmanager
, networkmanagerapplet
, wingpanel
, libgee
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-network";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0fch27imk5x4nfx49cwcylkxd7m289rl9niy1vx5kjplhbhyhdq2";
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
    networkmanager
    networkmanagerapplet
    wingpanel
  ];

  PKG_CONFIG_WINGPANEL_2_0_INDICATORSDIR = "${placeholder "out"}/lib/wingpanel";

  meta = with stdenv.lib; {
    description = "Network Indicator for Wingpanel";
    homepage = https://github.com/elementary/wingpanel-indicator-network;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
