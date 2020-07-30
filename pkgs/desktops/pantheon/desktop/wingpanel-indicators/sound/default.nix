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
, granite
, wingpanel
, libnotify
, pulseaudio
, libcanberra-gtk3
, libgee
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-sound";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0nla8qgn5gb1g2gn7c47m9zw42sarjd0030x3h5kckapsbaxknhp";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkgconfig
    python3
    vala
  ];

  buildInputs = [
    granite
    gtk3
    libcanberra-gtk3
    libgee
    libnotify
    pulseaudio
    wingpanel
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Sound Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-sound";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
