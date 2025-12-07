{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zita-resampler";
  version = "1.11.2";

  src = fetchzip {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/zita-resampler-${finalAttrs.version}.tar.xz";
    hash = "sha256-0lgpTOxf8y32GgYtcVbLDUDzyKvbsSZx3LKaDcdID6A=";
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
    homepage = "https://kokkinizita.linuxaudio.org/linuxaudio/index.html";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
})
