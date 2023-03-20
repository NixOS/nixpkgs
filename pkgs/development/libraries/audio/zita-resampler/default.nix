{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "zita-resampler";
  version = "1.8.0";

  src = fetchurl {
    url = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${pname}-${version}.tar.bz2";
    sha256 = "sha256-5XRPI8VN0Vs/eDpoe9h57uKmkKRUWhW0nEzwN6pGSqI=";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "SUFFIX="
  ];

  postPatch = ''
    cd source
    substituteInPlace Makefile \
      --replace 'ldconfig' ""
  '' + lib.optionalString (!stdenv.targetPlatform.isx86_64) ''
    substituteInPlace Makefile \
      --replace '-DENABLE_SSE2' ""
  '';

  fixupPhase = ''
    ln -s $out/lib/libzita-resampler.so.$version $out/lib/libzita-resampler.so.1
  '';

  meta = {
    description = "Resample library by Fons Adriaensen";
    version = version;
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/index.html";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
}
