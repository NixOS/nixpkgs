{
  lib,
  stdenv,
  fetchzip,
  fftwFloat,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zita-convolver";
  version = "4.0.3";

  src = fetchzip {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/zita-convolver-4.0.3.tar.bz2";
    hash = "sha256-f8a3sLcN6GMPV/8E/faqMYkJdUa7WqmQBrehH6kCJtc=";
  };

  sourceRoot = "${finalAttrs.src.name}/source";

  buildInputs = [ fftwFloat ];

  patchPhase = ''
    sed -e "s@ldconfig@@" -i Makefile
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "SUFFIX="
  ];

  postInstall = ''
    # create lib link for building apps
    ln -s \
     $out/lib/libzita-convolver.so.${finalAttrs.version} \
     $out/lib/libzita-convolver.so.${lib.versions.major finalAttrs.version}
  '';

  meta = {
    description = "Convolution library by Fons Adriaensen";
    homepage = "https://kokkinizita.linuxaudio.org/linuxaudio/index.html";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
})
