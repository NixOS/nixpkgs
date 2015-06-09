{ stdenv, fetchurl, libclthreads, libX11, libXft, xlibs }:

stdenv.mkDerivation rec {
  name = "libclxclient-${version}";
  version = "3.9.0";

  src = fetchurl {
    url = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/clxclient-${version}.tar.bz2";
    sha256 = "14l7xrh964gllymraq4n5pgax94p5jsfjslqi5c6637zc4lmgnl0";
  };

  buildInputs = [ libclthreads libX11 libXft xlibs.xproto ];

  NIX_CFLAGS_COMPILE = "-I${xlibs.xproto}/include -I${libXft}/include";

  patchPhase = ''
    sed -e "s@ldconfig@@" -i Makefile
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "SUFFIX=''"
  ];

  preInstall = ''
    # The Makefile does not create the include directory
    mkdir -p $out/include
  '';

  postInstall = ''
    ln $out/lib/libclxclient.so $out/lib/libclxclient.so.3
  '';

  meta = with stdenv.lib; {
    description = "Zita X11 library";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/index.html";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.linux;
  };
}
