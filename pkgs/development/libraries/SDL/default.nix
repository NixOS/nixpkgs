{ lib, stdenv, config, fetchFromGitHub, fetchpatch, pkg-config, audiofile, libcap, libiconv
, libGLSupported ? lib.elem stdenv.hostPlatform.system lib.platforms.mesaPlatforms
, openglSupport ? libGLSupported, libGL, libGLU
, alsaSupport ? stdenv.isLinux && !stdenv.hostPlatform.isAndroid, alsa-lib
, x11Support ? !stdenv.isCygwin && !stdenv.hostPlatform.isAndroid
, libXext, libICE, libXrandr
, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux && !stdenv.hostPlatform.isAndroid, libpulseaudio
, OpenGL, GLUT, CoreAudio, CoreServices, AudioUnit, Kernel, Cocoa
}:

# NOTE: When editing this expression see if the same change applies to
# SDL2 expression too

let
  extraPropagatedBuildInputs = [ ]
    ++ lib.optionals x11Support [ libXext libICE libXrandr ]
    ++ lib.optionals (openglSupport && stdenv.isLinux) [ libGL libGLU ]
    ++ lib.optionals (openglSupport && stdenv.isDarwin) [ OpenGL GLUT ]
    ++ lib.optional alsaSupport alsa-lib
    ++ lib.optional pulseaudioSupport libpulseaudio
    ++ lib.optional stdenv.isDarwin Cocoa;
  rpath = lib.makeLibraryPath extraPropagatedBuildInputs;
in

stdenv.mkDerivation rec {
  pname = "SDL";
  version = "1.2.15-unstable-2023-12-08";

  # 1.2.15 was released in 2013, 1.2.16 is not yet tagged
  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL-1.2";
    rev = "d5088e5db1bcf174f53379d543ff49093a9d6d72";
    hash = "sha256-TA8sclOcy+3oaKMimTrXH7YLNXhNmRqXI1V4Q97JrM4=";
  };

  outputs = [ "out" "dev" ];
  outputBin = "dev"; # sdl-config

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optional stdenv.isLinux libcap;

  propagatedBuildInputs = [ libiconv ] ++ extraPropagatedBuildInputs;

  buildInputs = [ ]
    ++ lib.optional (!stdenv.hostPlatform.isMinGW && alsaSupport) audiofile
    ++ lib.optionals stdenv.isDarwin [ AudioUnit CoreAudio CoreServices Kernel OpenGL ];

  configureFlags = [
    "--disable-oss"
    "--disable-video-x11-xme"
    "--enable-rpath"
  # Building without this fails on Darwin with
  #
  #   ./src/video/x11/SDL_x11sym.h:168:17: error: conflicting types for '_XData32'
  #   SDL_X11_SYM(int,_XData32,(Display *dpy,register long *data,unsigned len),(dpy,data,len),return)
  #
  # Please try revert the change that introduced this comment when updating SDL.
  ] ++ lib.optional stdenv.isDarwin "--disable-x11-shared"
    ++ lib.optional (!x11Support) "--without-x"
    ++ lib.optional alsaSupport "--with-alsa-prefix=${alsa-lib.out}/lib";

  patches = [
    ./find-headers.patch

    # Workaround X11 bug to allow changing gamma
    # Ticket: https://bugs.freedesktop.org/show_bug.cgi?id=27222
    (fetchpatch {
      name = "SDL_SetGamma.patch";
      url = "https://src.fedoraproject.org/rpms/SDL/raw/7a07323e5cec08bea6f390526f86a1ce5341596d/f/SDL-1.2.15-x11-Bypass-SetGammaRamp-when-changing-gamma.patch";
      sha256 = "0x52s4328kilyq43i7psqkqg7chsfwh0aawr50j566nzd7j51dlv";
    })
  ];

  postInstall = ''
    moveToOutput share/aclocal "$dev"
  '';

  # See the same place in the expression for SDL2
  postFixup = ''
    for lib in $out/lib/*.so* ; do
      if [[ -L "$lib" ]]; then
        patchelf --set-rpath "$(patchelf --print-rpath $lib):${rpath}" "$lib"
      fi
    done
  '';

  setupHook = ./setup-hook.sh;

  passthru = { inherit openglSupport; };

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A cross-platform multimedia library";
    mainProgram = "sdl-config";
    homepage    = "http://www.libsdl.org/";
    changelog   = "https://github.com/libsdl-org/SDL-1.2/blob/${src.rev}/WhatsNew";
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
    license     = licenses.lgpl21;
  };
}
