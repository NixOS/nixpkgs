{ stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, pkgconfig
, meson
, python3
, ninja
, vala
, gtk3
, glib
, granite
, libnotify
, wingpanel
, libgee
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-bluetooth";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0ylbpai05b300h07b94xcmw9xi7qx13l1q38zlg2n95d3c5264dp";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    glib # for glib-compile-schemas
    libxml2
    meson
    ninja
    pkgconfig
    python3
    vala
  ];

  buildInputs = [
    glib
    granite
    gtk3
    libgee
    libnotify
    wingpanel
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Bluetooth Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-bluetooth";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
