{ stdenv
, fetchFromGitHub
, pantheon
, pkgconfig
, meson
, ninja
, vala
, desktop-file-utils
, python3
, gettext
, libxml2
, gtk3
, granite
, libgee
, gst_all_1
, libcanberra
, clutter-gtk
, clutter-gst
, elementary-icon-theme
, appstream
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-camera";
  version = "1.0.5";

  repoName = "camera";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "05amcljvc3w77a1b0c76y6rha8g0zm6lqflvg1g7jzz00jchx9d4";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = "pantheon.${pname}";
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
