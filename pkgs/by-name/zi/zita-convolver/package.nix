{
  lib,
  stdenv,
<<<<<<< HEAD
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
=======
  fetchurl,
  fftwFloat,
}:

stdenv.mkDerivation rec {
  pname = "zita-convolver";
  version = "4.0.3";
  src = fetchurl {
    url = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${pname}-${version}.tar.bz2";
    sha256 = "0prji66p86z2bzminywkwchr5bfgxcg2i8y803pydd1hzf2198cs";
  };

  buildInputs = [ fftwFloat ];

  patchPhase = ''
    cd source
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    sed -e "s@ldconfig@@" -i Makefile
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "SUFFIX="
  ];

  postInstall = ''
    # create lib link for building apps
<<<<<<< HEAD
    ln -s \
     $out/lib/libzita-convolver.so.${finalAttrs.version} \
     $out/lib/libzita-convolver.so.${lib.versions.major finalAttrs.version}
=======
    ln -s $out/lib/libzita-convolver.so.${version} $out/lib/libzita-convolver.so.${lib.versions.major version}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  meta = {
    description = "Convolution library by Fons Adriaensen";
<<<<<<< HEAD
    homepage = "https://kokkinizita.linuxaudio.org/linuxaudio/index.html";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
})
=======
    version = version;
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/index.html";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
