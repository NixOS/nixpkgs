{ stdenv
, lib
, fetchFromGitHub
, fetchurl
, meson
, ninja
, pkg-config
, gst_all_1
, vosk-api
}:

stdenv.mkDerivation rec {
  pname = "gst-vosk";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "PhilippeRo";
    repo = "gst-vosk";
    rev = version;
    sha256 = "Ez0TS/WMexj45h1rpvrNAsl6ZKPuwsG9bqZBxrBE4jo=";
  };

  patches = [
    ./unvendor-vosk.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    gst_all_1.gstreamer
    vosk-api
  ];

  meta = with lib; {
    description = "GStreamer plug-in for VOSK";
    homepage = "https://github.com/PhilippeRo/gst-vosk";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = vosk-api.meta.platforms;
  };
}
