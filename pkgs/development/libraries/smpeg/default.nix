{ lib, stdenv, fetchFromGitHub, SDL, autoconf, automake, libtool, gtk2, m4, pkg-config, libGLU, libGL, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "smpeg";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "icculus";
    repo = "smpeg";
    rev = "release_${builtins.replaceStrings ["."] ["_"] version}";
    sha256 = "sha256-nq/i7cFGpJXIuTwN/ScLMX7FN8NMdgdsRM9xOD3uycs=";
  };

  patches = [
    ./format.patch
    ./gcc6.patch
    ./libx11.patch
    ./gtk.patch
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoconf automake libtool m4 pkg-config makeWrapper ];

  buildInputs = [ SDL gtk2 libGLU libGL ];

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
      --prefix PATH ":" "${pkg-config}/bin" \
      --prefix PKG_CONFIG_PATH ":" "${lib.getDev SDL}/lib/pkgconfig"
  '';

  NIX_LDFLAGS = "-lX11";

  meta = {
    homepage = "http://icculus.org/smpeg/";
    description = "MPEG decoding library";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
