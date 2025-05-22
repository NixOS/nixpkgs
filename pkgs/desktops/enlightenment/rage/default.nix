{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  efl,
  gst_all_1,
  wrapGAppsHook3,
  directoryListingUpdater,
}:

stdenv.mkDerivation rec {
  pname = "rage";
  version = "0.4.0";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "03yal7ajh57x2jhmygc6msf3gzvqkpmzkqzj6dnam5sim8cq9rbw";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    efl
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav
  ];

  passthru.updateScript = directoryListingUpdater { };

  meta = with lib; {
    description = "Video and audio player along the lines of mplayer";
    mainProgram = "rage";
    homepage = "https://enlightenment.org/";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      matejc
      ftrvxmtrx
    ];
    teams = [ teams.enlightenment ];
  };
}
