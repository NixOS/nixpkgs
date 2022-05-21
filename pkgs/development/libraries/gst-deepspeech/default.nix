{ stdenv
, lib
, fetchFromGitHub
, fetchurl
, autoreconfHook
, pkg-config
, gst_all_1
, stt
, stt-models
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "gst-deepspeech";
  version = "unstable-2021-04-08";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "Elleo";
    repo = "gst-deepspeech";
    rev = "2aef372a7a1064c90ffb70c12721657bf92fca66";
    sha256 = "9XGSUYV6jRMsMSA8TO7y7u9T7NihB4azzKJfZ/OPcLI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    stt
  ];

  postPatch = ''
    # https://github.com/Elleo/gst-deepspeech/pull/20
    substituteInPlace src/gstdeepspeech.cc \
      --replace "/usr/share/deepspeech/models/deepspeech-0.9.3-models.pbmm" "${stt-models.english.tflite}" \
      --replace "/usr/share/deepspeech/models/deepspeech-0.9.3-models.scorer" "${stt-models.english.scorer}" \
      --replace "#include <deepspeech.h>" "" \
      --replace "DS_" "STT_"
    substituteInPlace src/gstdeepspeech.h \
      --replace '#include "deepspeech.h"' "#include <coqui-stt.h>"
    substituteInPlace src/Makefile.am \
      --replace "-ldeepspeech" "-lstt"
  '';

  passthru = {
    updateScript = unstableGitUpdater {
      url = "${src.meta.homepage}.git";
    };
  };

  meta = {
    description = "GStreamer plug-in for STT";
    homepage = "https://github.com/Elleo/gst-deepspeech";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ jtojnar ];
    platforms = stt.meta.platforms;
  };
}
