{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pkg-config
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
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-t8Sn8NQW7WueinPkJdn8hd0oCJ3uFeRJliggSFHoaZU=";
  };

  patches = [
    # Prevent a race that skips automatic resource loading
    # https://github.com/elementary/wingpanel-indicator-bluetooth/issues/203
    (fetchpatch {
      url = "https://github.com/elementary/wingpanel-indicator-bluetooth/commit/4f9237c0cb1152a696ccdd2a2fc83fc706f54d62.patch";
      sha256 = "sha256-fUnqw0EAWvtpoo2wI++2B5kXNqQPxnsjPbZ7O30lXBI=";
    })
  ];

  nativeBuildInputs = [
    glib # for glib-compile-schemas
    libxml2
    meson
    ninja
    pkg-config
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

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Bluetooth Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-bluetooth";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
