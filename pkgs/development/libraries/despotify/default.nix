{
  stdenv, fetchsvn, openssl, zlib, libvorbis, pulseaudio, gstreamer, libao,
  libtool, ncurses, glibc
}:

stdenv.mkDerivation rec {

  name = "despotify";

  src = fetchsvn {
    url = "https://despotify.svn.sourceforge.net/svnroot/despotify";
    rev = "521";
  };

  buildInputs = [
    openssl zlib libvorbis pulseaudio gstreamer libao libtool ncurses glibc
  ];

  configurePhase = "cd src";

  installPhase = "make LDCONFIG=true INSTALL_PREFIX=$out install";

  meta = {
    homepage = "despotify.se";
  };

}
