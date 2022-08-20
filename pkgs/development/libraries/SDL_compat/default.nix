{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, SDL2
, libGLSupported ? lib.elem stdenv.hostPlatform.system lib.platforms.mesaPlatforms
, openglSupport ? libGLSupported
, libGL
, libGLU
}:

let
  inherit (lib) optionals makeLibraryPath;

in
stdenv.mkDerivation rec {
  pname = "SDL_compat";
  version = "1.2.52";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "sdl12-compat";
    rev = "release-" + version;
    hash = "sha256-PDGlMI8q74JaqMQ5oX9Zt5CEr7frFQWECbuwq5g25eg=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  propagatedBuildInputs = [ SDL2 ]
    ++ optionals openglSupport [ libGL libGLU ];

  enableParallelBuilding = true;

  setupHook = ../SDL/setup-hook.sh;

  postFixup = ''
    for lib in $out/lib/*.so* ; do
      if [[ -L "$lib" ]]; then
        patchelf --set-rpath "$(patchelf --print-rpath $lib):${makeLibraryPath propagatedBuildInputs}" "$lib"
      fi
    done
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A cross-platform multimedia library - build SDL 1.2 applications against 2.0";
    homepage = "https://www.libsdl.org/";
    license = licenses.zlib;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.all;
  };
}
