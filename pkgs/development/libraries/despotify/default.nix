{
  stdenv, fetchsvn, openssl, zlib, libvorbis, libpulseaudio, gstreamer, libao,
  libtool, ncurses, glibc
}:

stdenv.mkDerivation rec {

  name = "despotify-svn521";

  src = fetchsvn {
    url = "http://svn.code.sf.net/p/despotify/code";
    rev = "521";
    sha256 = "1vc453bv5ngkvaqkq7z5bj6x28m4kik59153jikcfah3k4qmxw21";
  };

  buildInputs = [
    openssl zlib libvorbis libpulseaudio gstreamer libao libtool ncurses glibc
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
    platforms = stdenv.lib.platforms.linux;
  };

}
