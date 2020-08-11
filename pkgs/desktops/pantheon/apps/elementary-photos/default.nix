{ stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, meson
, ninja
, pkgconfig
, vala
, desktop-file-utils
, gtk3
, libaccounts-glib
, libexif
, libgee
, geocode-glib
, gexiv2
, libgphoto2
, granite
, gst_all_1
, libgudev
, json-glib
, libraw
, librest
, libsoup
, sqlite
, python3
, scour
, webkitgtk
, libwebp
, appstream
, libunity
, wrapGAppsHook
, elementary-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "elementary-photos";
  version = "2.7.0";

  repoName = "photos";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "09jjic165rmprc2cszsgj2m3j3f5p8v9pxx5mj66a0gj3ar3hfbd";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
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
    librest
    libsoup
    libunity
    libwebp
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
    homepage = "https://github.com/elementary/photos";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
