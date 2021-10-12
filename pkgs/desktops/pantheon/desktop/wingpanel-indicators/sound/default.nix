{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pantheon
, pkg-config
, meson
, python3
, ninja
, vala_0_52
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
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0cv97c0qrhqisyghy9a9qr4ffcx3g4bkswxm6rn4r2wfg4gvljri";
  };

  patches = [
    # Upstream code not respecting our localedir
    # https://github.com/elementary/wingpanel-indicator-sound/pull/216
    (fetchpatch {
      url = "https://github.com/elementary/wingpanel-indicator-sound/commit/df816104c15e4322c1077313b1f43114cdaf710e.patch";
      sha256 = "029z7l467jz1ymxwrzrf874062r6xmskl7mldpq39jh110fijy5l";
    })
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkg-config
    python3
    # Does not build with vala 0.54
    # https://github.com/elementary/wingpanel-indicator-sound/issues/219
    vala_0_52
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

  meta = with lib; {
    description = "Sound Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-sound";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
