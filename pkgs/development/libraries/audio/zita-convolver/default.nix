{ stdenv, fetchurl, fftwFloat }:

stdenv.mkDerivation rec {
  name = "zita-convolver-${version}";
  version = "3.1.0";
  src = fetchurl {
    url = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${name}.tar.bz2";
    sha256 = "14qrnczhp5mbwhky64il7kxc4hl1mmh495v60va7i2qnhasr6zmz";
  };

  buildInputs = [ fftwFloat ];

  patchPhase = ''
    cd libs
    sed -e "s@ldconfig@@" -i Makefile
  '';

  installPhase = ''
    make PREFIX="$out" SUFFIX="" install

    # create lib link for building apps
    ln -s $out/lib/libzita-convolver.so.$version $out/lib/libzita-convolver.so.3
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
