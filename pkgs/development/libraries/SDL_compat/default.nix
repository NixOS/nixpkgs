{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, SDL2
, libiconv
, Cocoa
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
  version = "1.2.60";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "sdl12-compat";
    rev = "release-" + version;
    hash = "sha256-8b9rFI4iRpBJqeJ2KRJ9vRyv9gYwa9jRWCuXRfA3x50=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  propagatedBuildInputs = [ SDL2 ]
    ++ optionals stdenv.hostPlatform.isDarwin [ libiconv Cocoa ]
    ++ optionals openglSupport [ libGL libGLU ];

  enableParallelBuilding = true;

  setupHook = ../SDL/setup-hook.sh;

  postFixup = ''
    for lib in $out/lib/*${stdenv.hostPlatform.extensions.sharedLibrary}* ; do
      if [[ -L "$lib" ]]; then
        ${if stdenv.hostPlatform.isDarwin then ''
          install_name_tool ${lib.strings.concatMapStrings (x: " -add_rpath ${makeLibraryPath [x]} ") propagatedBuildInputs} "$lib"
        '' else ''
          patchelf --set-rpath "$(patchelf --print-rpath $lib):${makeLibraryPath propagatedBuildInputs}" "$lib"
        ''}
      fi
    done
  '';

  meta = with lib; {
    description = "A cross-platform multimedia library - build SDL 1.2 applications against 2.0";
    homepage = "https://www.libsdl.org/";
    license = licenses.zlib;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.all;
  };
}
