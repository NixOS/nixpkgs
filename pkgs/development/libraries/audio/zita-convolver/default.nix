{ stdenv, fetchurl, fftwFloat }:

stdenv.mkDerivation rec {
  name = "zita-convolver-${version}";
  version = "4.0.0";
  src = fetchurl {
    url = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${name}.tar.bz2";
    sha256 = "0fx7f48ls0rlndqrmd4k7ifpnml39yxzc2f0n6xyysypgn06y673";
  };

  buildInputs = [ fftwFloat ];

  patchPhase = ''
    cd libs
    sed -e "s@ldconfig@@" -i Makefile
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "SUFFIX="
  ];

  postInstall = ''
    # create lib link for building apps
    ln -s $out/lib/libzita-convolver.so.${version} $out/lib/libzita-convolver.so.${stdenv.lib.versions.major version}
  '';

  meta = {
    description = "Convolution library by Fons Adriaensen";
    version = "${version}";
    homepage = http://kokkinizita.linuxaudio.org/linuxaudio/downloads/index.html;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
