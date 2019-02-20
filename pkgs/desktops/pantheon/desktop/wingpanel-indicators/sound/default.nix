{ stdenv, fetchFromGitHub, pantheon, pkgconfig, meson
, python3, ninja, vala, gtk3, granite, wingpanel, libnotify
, pulseaudio, libcanberra-gtk3, libgee, libxml2, wrapGAppsHook
, gobject-introspection, elementary-icon-theme }:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-sound";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0hxbr5dp8d1czq8ffw339r41c7srqb72vr48hxph8g091d3mcgcl";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
    };
  };

  nativeBuildInputs = [
    gobject-introspection
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
    libcanberra-gtk3
    libgee
    libnotify
    pulseaudio
    wingpanel
  ];

  PKG_CONFIG_WINGPANEL_2_0_INDICATORSDIR = "lib/wingpanel";

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Sound Indicator for Wingpanel";
    homepage = https://github.com/elementary/wingpanel-indicator-sound;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
