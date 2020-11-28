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
  version = "unstable-2020-10-01";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "2b59d646ea0d66ae45dafc851374f24dcd98c064";
    sha256 = "sha256-selp70P+7RhbdHF6iiNmcNbMf/c+B9zZ6nlxwRSZGn4=";
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
