{ stdenv, fetchsvn, SDL, autoconf, automake, libtool, gtk, m4, pkgconfig, mesa }:

stdenv.mkDerivation rec {
  name = "smpeg-svn-${version}";
  version = "390";

  src = fetchsvn {
    url = svn://svn.icculus.org/smpeg/trunk;
    rev = version;
    sha256 = "0ynwn7ih5l2b1kpzpibns9bb9wzfjak7mgrb1ji0dkn2q5pv6lr0";
  };

  enableParallelBuilding = true;

  buildInputs = [ SDL autoconf automake libtool gtk m4 pkgconfig mesa ];

  preConfigure = ''
    touch NEWS AUTHORS ChangeLog
    sh autogen.sh
  '';

  postInstall = ''
    sed -i -e 's,"SDL.h",<SDL/SDL.h>,' \
    -e 's,"SDL_mutex.h",<SDL/SDL_mutex.h>,' \
    -e 's,"SDL_audio.h",<SDL/SDL_audio.h>,' \
    -e 's,"SDL_thread.h",<SDL/SDL_thread.h>,' \
    -e 's,"SDL_types.h",<SDL/SDL_types.h>,' \
      $out/include/smpeg/*.h
  '';

  meta = {
    homepage = http://icculus.org/smpeg/;
    description = "MPEG decoding library";
    license = "GPLv2+";
  };
}
