{
  lib,
  stdenv,
<<<<<<< HEAD
  fetchzip,
=======
  fetchurl,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zita-resampler";
  version = "1.11.2";

<<<<<<< HEAD
  src = fetchzip {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/zita-resampler-${finalAttrs.version}.tar.xz";
    hash = "sha256-0lgpTOxf8y32GgYtcVbLDUDzyKvbsSZx3LKaDcdID6A=";
  };

  sourceRoot = "${finalAttrs.src.name}/source";

=======
  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/zita-resampler-${finalAttrs.version}.tar.xz";
    hash = "sha256-qlxU5pYGmvJvPx/tSpYxE8wSN83f1XrlhCq8sazVSSw=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  makeFlags = [
    "PREFIX=$(out)"
    "SUFFIX="
  ];

<<<<<<< HEAD
  postPatch = lib.optionalString (!stdenv.hostPlatform.isx86_64) ''
=======
  postPatch = ''
    cd source
  ''
  + lib.optionalString (!stdenv.hostPlatform.isx86_64) ''
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    substituteInPlace Makefile \
      --replace-fail '-DENABLE_SSE2' ""
  '';

  meta = {
    description = "Resample library by Fons Adriaensen";
<<<<<<< HEAD
    homepage = "https://kokkinizita.linuxaudio.org/linuxaudio/index.html";
    license = lib.licenses.gpl3Only;
=======
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/index.html";
    license = lib.licenses.gpl2;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
})
