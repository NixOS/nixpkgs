{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  libX11,
  libGL,
  liblo,
  libjack2,
  ladspaH,
  lv2,
  pkg-config,
  rubberband,
  libsndfile,
  fftwFloat,
  libsamplerate,
}:

stdenv.mkDerivation rec {
  pname = "zam-plugins";
  version = "4.3";

  src = fetchFromGitHub {
    owner = "zamaudio";
    repo = pname;
    rev = version;
    hash = "sha256-wT1BXQrcD+TI+trqx0ZVUmVLZMTDQgJI3dAvN54wy6Y=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boost
    libX11
    libGL
    liblo
    libjack2
    ladspaH
    lv2
    rubberband
    libsndfile
    fftwFloat
    libsamplerate
  ];

  postPatch = ''
    patchShebangs ./dpf/utils/generate-ttl.sh
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://www.zamaudio.com/?p=976";
    description = "Collection of LV2/LADSPA/VST/JACK audio plugins by ZamAudio";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
}
