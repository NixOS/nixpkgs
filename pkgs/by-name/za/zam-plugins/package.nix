{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  libx11,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "zam-plugins";
  version = "4.4";

  src = fetchFromGitHub {
    owner = "zamaudio";
    repo = "zam-plugins";
    tag = finalAttrs.version;
    hash = "sha256-pjnhDavKnyQjPF4nUO+j1J+Qtw8yIYMY9A5zBMb4zFU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boost
    libx11
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
    for f in plugins/*/Makefile; do
      substituteInPlace "$f" \
        --replace-quiet 'pkg-config' '${stdenv.cc.targetPrefix}pkg-config'
    done
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
    # tries to run dpf/utils/lv2_ttl_generator (built for host)
    broken = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  };
})
