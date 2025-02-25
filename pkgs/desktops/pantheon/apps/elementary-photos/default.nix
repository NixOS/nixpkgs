{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  gtk3,
  libexif,
  libgee,
  libhandy,
  libportal-gtk3,
  geocode-glib_2,
  gexiv2,
  libgphoto2,
  granite,
  gst_all_1,
  libgudev,
  libraw,
  sqlite,
  libwebp,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "elementary-photos";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "photos";
    rev = version;
    sha256 = "sha256-+aqBeGRisngbH/EALROTr0IZvyrWIlQvFFEgJNfv95Y=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs =
    [
      geocode-glib_2
      gexiv2
      granite
      gtk3
      libexif
      libgee
      libgphoto2
      libgudev
      libhandy
      libportal-gtk3
      libraw
      libwebp
      sqlite
    ]
    ++ (with gst_all_1; [
      gst-plugins-bad
      gst-plugins-base
      gst-plugins-good
      gst-plugins-ugly
      gstreamer
    ]);

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
