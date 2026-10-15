{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  cairo,
  libx11,
  libjack2,
  liblo,
  libsigcxx_2_0,
  zita-resampler,
  fftwFloat,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xtuner";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = "XTuner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O8M10Yu7qCTa+cQt1DWvGJl1k2Xmp2g/35HB4ayDrMQ=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix build against glibc-2.38.
    (fetchpatch {
      name = "glibc-2.38.patch";
      url = "https://github.com/brummer10/libxputty/commit/7eb70bf3f7bce0af9e1919d6c875cdb8efca734e.patch";
      hash = "sha256-VspR0KJjBt4WOrnlo7rHw1oAYM1d2RSz6JhuAEfsO3M=";
      stripLen = 1;
      extraPrefix = "libxputty/";
    })
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    cairo
    libx11
    libjack2
    liblo
    libsigcxx_2_0
    zita-resampler
    fftwFloat
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/brummer10/XTuner";
    description = "Tuner for Jack Audio Connection Kit";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.linux;
    mainProgram = "xtuner";
  };
})
