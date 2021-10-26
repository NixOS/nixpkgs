{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pantheon
, meson
, ninja
, pkg-config
, vala
, desktop-file-utils
, gtk3
, libaccounts-glib
, libexif
, libgee
, libhandy
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
, wrapGAppsHook
, elementary-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "elementary-photos";
  version = "2.7.2";

  repoName = "photos";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "1zq9zfsc987vvrzadw9xqi3rlbi4jv2s82axkgy7ijm3ibi58ddc";
  };

  patches = [
    # Fix build with vala 0.54
    # https://github.com/elementary/photos/pull/650
    (fetchpatch {
      url = "https://github.com/elementary/photos/commit/bc7feca8caa4c8fc076a759a2d36e26e93c75596.patch";
      sha256 = "sha256-iOHYKV7rSAuMm4ZhoJWjlpu96zlxwTosQe+z/iEVFR8=";
    })
  ];

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    meson
    ninja
    pkg-config
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
    libhandy
    libraw
    librest
    libsoup
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

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta =  with lib; {
    description = "Photo viewer and organizer designed for elementary OS";
    homepage = "https://github.com/elementary/photos";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
