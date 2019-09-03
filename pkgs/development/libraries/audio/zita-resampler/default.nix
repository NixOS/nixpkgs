{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "zita-resampler";
  version = "1.6.2";
  src = fetchurl {
    url = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${pname}-${version}.tar.bz2";
    sha256 = "1my5k2dh2dkvjp6xjnf9qy6i7s28z13kw1n9pwa4a2cpwbzawfr3";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "SUFFIX="
  ];

  patchPhase = ''
    cd source
    sed -e "s@ldconfig@@" -i Makefile
  '';

  fixupPhase = ''
    ln -s $out/lib/libzita-resampler.so.$version $out/lib/libzita-resampler.so.1
  '';

  meta = {
    description = "Resample library by Fons Adriaensen";
    version = "${version}";
    homepage = http://kokkinizita.linuxaudio.org/linuxaudio/downloads/index.html;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
