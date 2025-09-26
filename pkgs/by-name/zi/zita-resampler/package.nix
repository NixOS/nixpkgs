{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zita-resampler";
  version = "1.11.2";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/zita-resampler-${finalAttrs.version}.tar.xz";
    hash = "sha256-qlxU5pYGmvJvPx/tSpYxE8wSN83f1XrlhCq8sazVSSw=";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "SUFFIX="
  ];

  postPatch = ''
    cd source
  ''
  + lib.optionalString (!stdenv.hostPlatform.isx86_64) ''
    substituteInPlace Makefile \
      --replace-fail '-DENABLE_SSE2' ""
  '';

  meta = {
    description = "Resample library by Fons Adriaensen";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/index.html";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
})
