{ stdenv, fetchFromGitHub, pantheon, pkgconfig, meson, ninja, vala, python3
, desktop-file-utils, gtk3, granite, libgee, clutter-gst, clutter-gtk, gst_all_1
, gobject-introspection, elementary-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "videos";
  version = "2.6.3";

  name = "elementary-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1ncm8kh6dcy83p8pmpilnk03b4dx3b1jm8w13izq2dkglfgdwvqx";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
      attrPath = "elementary-${pname}";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = with gst_all_1; [
    clutter-gst
    clutter-gtk
    elementary-icon-theme
    granite
    gst-libav
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
    gtk3
    libgee
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Video player and library app designed for elementary OS";
    homepage = https://github.com/elementary/videos;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
