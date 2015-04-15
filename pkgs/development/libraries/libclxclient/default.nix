{ stdenv, fetchurl, libclthreads, libXft, libX11 }:

stdenv.mkDerivation rec {
  name = "libclxclient-${version}";
  version = "3.9.0";
  src = fetchurl {
    url = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/clxclient-${version}.tar.bz2";
    sha256 = "14l7xrh964gllymraq4n5pgax94p5jsfjslqi5c6637zc4lmgnl0";
  };

  buildInputs = [
    libclthreads libXft libX11
  ];

  configurePhase = ''
    sed -e "s@/usr/local@$out@" -i Makefile
    sed -e "s@#include <clthreads.h>@#include <${libclthreads}/include>@" -i clxclient.h
    sed -e "s@ldconfig@@" -i Makefile
    sed -e "s@SUFFIX :=.*@SUFFIX =@" -i Makefile
  '';

  fixupPhase = ''
    ln $out/lib/libclxclient.so $out/lib/libclxclient.so.3
  '';

  meta = {
    description = ''
    '';
    longDescription = ''
    '';
    version = "${version}";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/index.html";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
