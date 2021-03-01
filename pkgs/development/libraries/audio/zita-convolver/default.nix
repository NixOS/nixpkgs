{ lib, stdenv, fetchurl, fftwFloat }:

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
    sed -e "s@ldconfig@@" -i Makefile
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "SUFFIX="
  ];

  postInstall = ''
    # create lib link for building apps
    ln -s $out/lib/libzita-convolver.so.${version} $out/lib/libzita-convolver.so.${lib.versions.major version}
  '';

  meta = {
    description = "Convolution library by Fons Adriaensen";
    version = version;
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/index.html";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
}
