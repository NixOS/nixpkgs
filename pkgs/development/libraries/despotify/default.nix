{
  stdenv, fetchsvn, openssl, zlib, libvorbis, pulseaudio, gstreamer, libao,
  libtool, ncurses, glibc
}:

stdenv.mkDerivation rec {

  name = "despotify-svn521";

  src = fetchsvn {
    url = "http://svn.code.sf.net/p/despotify/code";
    rev = "521";
  };

  buildInputs = [
    openssl zlib libvorbis pulseaudio gstreamer libao libtool ncurses glibc
  ];

  configurePhase = "cd src";

  installPhase = "make LDCONFIG=true INSTALL_PREFIX=$out install";

  meta = {
    description = "Open source Spotify client and library";
    longDescription = ''
      despotify is a open source implementation of the Spotify API.  This
      package provides both a library and a few already quite useful,
      proof-of-concept clients.
    '';
    homepage = "http://despotify.se";
    license = stdenv.lib.licenses.bsd2;
  };

}
