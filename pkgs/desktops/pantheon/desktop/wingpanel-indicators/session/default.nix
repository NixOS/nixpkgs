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
  version = "2.2.8";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "02inp8xdxfx8qxjdf2nazw46ahp1gv3skd922ma6kgx5w4wxh5l8";
  };

  patches = [
    # build failure in vala 0.48.7
    # https://github.com/elementary/gala/pull/869#issuecomment-657147695
    (fetchpatch {
      url = "https://github.com/elementary/wingpanel-indicator-session/commit/ead6971c708eed8b844bd9acd7eed2ab8a97e803.patch";
      sha256 = "1v7w7zdia82d38ycr5zhckaxgf7gr15hsv05cv5khlki8frryn2x";
    })
    (fetchpatch {
      url = "https://github.com/elementary/wingpanel-indicator-session/commit/85347e676054635ac878fc542bd057398ca70d3e.patch";
      sha256 = "1vw4zx0qbhxmfzqhdcmwdp4fxvij7n3f5lwcplf5v3k9qsr3wm0n";
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
