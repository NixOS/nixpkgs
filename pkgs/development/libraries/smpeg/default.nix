{ stdenv, fetchsvn, SDL, autoconf, automake, libtool, gtk2, m4, pkgconfig, libGLU_combined, makeWrapper }:

stdenv.mkDerivation rec {
  name = "smpeg-svn${version}";
  version = "390";

  src = fetchsvn {
    url = svn://svn.icculus.org/smpeg/trunk;
    rev = version;
    sha256 = "0ynwn7ih5l2b1kpzpibns9bb9wzfjak7mgrb1ji0dkn2q5pv6lr0";
  };

  patches = [
    ./format.patch
    ./gcc6.patch
  ];

  enableParallelBuilding = true;

  buildInputs = [ SDL gtk2 libGLU_combined ];

  nativeBuildInputs = [ autoconf automake libtool m4 pkgconfig makeWrapper ];

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

    wrapProgram $out/bin/smpeg-config \
      --prefix PATH ":" "${pkgconfig}/bin" \
      --prefix PKG_CONFIG_PATH ":" "${SDL.dev}/lib/pkgconfig"
  '';

  meta = {
    homepage = http://icculus.org/smpeg/;
    description = "MPEG decoding library";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
