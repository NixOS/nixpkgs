{ stdenv, fetchFromGitHub, pantheon, pkgconfig, meson, ninja, vala
, desktop-file-utils, python3, gettext, libxml2, gtk3, granite, libgee, gst_all_1
, libcanberra, clutter-gtk, clutter-gst, elementary-icon-theme, appstream, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "camera";
  version = "1.0.3";

  name = "elementary-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "05rjymflhwbkw8yc57rgi9n7lrhf4dpvfvlifdnazyqn9iiaxc46";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
      attrPath = "elementary-${pname}";
    };
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    gettext
    libxml2
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    clutter-gst
    clutter-gtk
    elementary-icon-theme
    granite
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
    gtk3
    libcanberra
    libgee
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Camera app designed for elementary OS";
    homepage = https://github.com/elementary/camera;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
