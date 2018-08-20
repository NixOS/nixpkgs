{ stdenv, fetchFromGitHub, pantheon, meson, ninja, pkgconfig, vala, desktop-file-utils
, gtk3, glib, libaccounts-glib, libexif, libgee, geocode-glib, gexiv2,libgphoto2
, granite, gst_all_1, libgudev, json-glib, libraw, librest, libsoup, sqlite
, scour, webkitgtk, libwebp, appstream, libunity, wrapGAppsHook, gobject-introspection, elementary-icon-theme }:

stdenv.mkDerivation rec {
  pname = "photos";
  version = "2.6.1";

  name = "elementary-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "063h6jr0p8v46w8bppsss1zlphx21xqwylh57qbyd5xi71z4gl1v";
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

  # This should be provided by a post_install.py script - See -> https://github.com/elementary/photos/pull/433
  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta =  with stdenv.lib; {
    description = "Photo viewer and organizer designed for elementary OS";
    homepage = https://github.com/elementary/photos;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
