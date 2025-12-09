{
  lib,
  stdenv,
  fetchFromGitea,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
  libsoup_3,
  json-glib,
  libsecret,
  glib-networking,

  # Per the upstream request. Key owned by Aleksana
  lastfmKey ? "b5027c5178ca2abfcc31bd04397c3c0e",
  lastfmSecret ? "8d375bdee925a2a35f241c04272bc862",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "turntable";
  version = "0.3.3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "GeopJr";
    repo = "Turntable";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fBduW49eNOEzRVBb72zcB5arTjTiRUy8jE3sSMjPITE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
    libsoup_3
    json-glib
    libsecret
    glib-networking
  ];

  mesonFlags = [
    (lib.mesonOption "lastfm_key" lastfmKey)
    (lib.mesonOption "lastfm_secret" lastfmSecret)
  ];

  strictDeps = true;

  meta = {
    description = "Scrobbles your music to multiple services with playback controls for MPRIS players";
    longDescription = ''
      Keep track of your listening habits by scrobbling them
      to last.fm, ListenBrainz, Libre.fm and Maloja at the
      same time using your favorite music app's, favorite
      music app! Turntable comes with a highly customizable
      and sleek design that displays information about the
      currently playing song and allows you to control your
      music player, allowlist it for scrobbling and manage
      your scrobbling accounts. All MPRIS-enabled apps are
      supported.
    '';
    homepage = "https://turntable.geopjr.dev";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ aleksana ];
    mainProgram = "dev.geopjr.Turntable";
    platforms = lib.platforms.linux;
  };
})
