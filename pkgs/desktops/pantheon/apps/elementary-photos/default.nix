{ stdenv, fetchFromGitHub, pantheon, meson, ninja, pkgconfig, vala, desktop-file-utils
, gtk3, glib, libaccounts-glib, libexif, libgee, geocode-glib, gexiv2,libgphoto2, fetchpatch
, granite, gst_all_1, libgudev, json-glib, libraw, librest, libsoup, sqlite, python3
, scour, webkitgtk, libwebp, appstream, libunity, wrapGAppsHook, gobject-introspection, elementary-icon-theme }:

stdenv.mkDerivation rec {
  pname = "photos";
  version = "2.6.4";

  name = "elementary-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "17r9658s0pqy6s45ysi3915sm8hpvmsp7cw2jahqvjc61r4qpdc1";
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
    gobject-introspection
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = with gst_all_1; [
    elementary-icon-theme
    geocode-glib
    gexiv2
    granite
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
    gtk3
    json-glib
    libaccounts-glib
    libexif
    libgee
    libgphoto2
    libgudev
    libraw
    libsoup
    libunity
    libwebp
    librest
    scour
    sqlite
    webkitgtk
  ];

  mesonFlags = [
    "-Dplugins=false"
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta =  with stdenv.lib; {
    description = "Photo viewer and organizer designed for elementary OS";
    homepage = https://github.com/elementary/photos;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
