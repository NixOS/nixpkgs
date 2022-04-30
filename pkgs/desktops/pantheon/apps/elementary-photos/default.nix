{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, desktop-file-utils
, gtk3
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
, webkitgtk
, libwebp
, appstream
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-photos";
  version = "2.7.4";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "photos";
    rev = version;
    sha256 = "sha256-NhF/WgS6IOwgALSCNyFNxz8ROVTb+mUX+lBtnWEyhEI=";
  };

  patches = [
    # Fix build with vala 0.56
    # https://github.com/elementary/photos/pull/711
    (fetchpatch {
      url = "https://github.com/elementary/photos/commit/6594f1323726fb0d38519a7bdafe16f9170353cb.patch";
      sha256 = "sha256-Ie9ULC8Xw4KLQJANPXh4LDywMjWfniPX/P76eHW8LHc=";
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

  buildInputs = [
    geocode-glib
    gexiv2
    granite
    gtk3
    json-glib
    libexif
    libgee
    libgphoto2
    libgudev
    libhandy
    libraw
    librest
    libsoup
    libwebp
    sqlite
    webkitgtk
  ] ++ (with gst_all_1; [
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
  ]);

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

  meta = with lib; {
    description = "Photo viewer and organizer designed for elementary OS";
    homepage = "https://github.com/elementary/photos";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.photos";
  };
}
