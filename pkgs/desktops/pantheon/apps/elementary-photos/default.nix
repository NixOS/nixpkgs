{ lib
, stdenv
, fetchFromGitHub
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
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "photos";
    rev = version;
    sha256 = "sha256-VhJggQMy1vk21zNA5pR4uAPGCwnIxLUHVO58AZs+h6s=";
  };

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
    updateScript = nix-update-script { };
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
