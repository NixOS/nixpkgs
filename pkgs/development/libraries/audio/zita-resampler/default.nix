{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "zita-resampler-${version}";
  version = "1.3.0";
  src = fetchurl {
    url = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${name}.tar.bz2";
    sha256 = "0r9ary5sc3y8vba5pad581ha7mgsrlyai83w7w4x2fmhfy64q0wq";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "SUFFIX="
  ];

  patchPhase = ''
    cd libs
    sed -e "s@ldconfig@@" -i Makefile
  '';

  fixupPhase = ''
    ln -s $out/lib/libzita-resampler.so.$version $out/lib/libzita-resampler.so.1
  '';

  meta = {
    description = "Resample library by Fons Adriaensen";
    version = "${version}";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/index.html";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
