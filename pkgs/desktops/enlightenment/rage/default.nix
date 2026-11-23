{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  efl,
  gstreamer,
  gst-plugins-good,
  gst-plugins-base,
  gst-plugins-bad,
  gst-libav,
  wrapGAppsHook3,
  directoryListingUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rage";
  version = "0.4.0";

  src = fetchurl {
    url = "https://download.enlightenment.org/rel/apps/rage/rage-${finalAttrs.version}.tar.xz";
    hash = "sha256-fOWEGapRl6psM/Lj+eudeP83nK6GPV+hFP0UKNWhyg8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    efl
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-libav
  ];

  passthru.updateScript = directoryListingUpdater { };

  meta = {
    description = "Video and audio player along the lines of mplayer";
    mainProgram = "rage";
    homepage = "https://enlightenment.org/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      matejc
    ];
    teams = [ lib.teams.enlightenment ];
  };
})
