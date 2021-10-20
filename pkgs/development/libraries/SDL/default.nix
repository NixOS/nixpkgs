{ lib, stdenv, config, fetchurl, fetchpatch, pkg-config, audiofile, libcap, libiconv
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

with lib;

let
  extraPropagatedBuildInputs = [ ]
    ++ optionals x11Support [ libXext libICE libXrandr ]
    ++ optionals (openglSupport && stdenv.isLinux) [ libGL libGLU ]
    ++ optionals (openglSupport && stdenv.isDarwin) [ OpenGL GLUT ]
    ++ optional alsaSupport alsa-lib
    ++ optional pulseaudioSupport libpulseaudio
    ++ optional stdenv.isDarwin Cocoa;
  rpath = makeLibraryPath extraPropagatedBuildInputs;
in

stdenv.mkDerivation rec {
  pname = "SDL";
  version = "1.2.15";

  src = fetchurl {
    url    = "https://www.libsdl.org/release/${pname}-${version}.tar.gz";
    sha256 = "005d993xcac8236fpvd1iawkz4wqjybkpn8dbwaliqz5jfkidlyn";
  };

  # make: *** No rule to make target 'build/*.lo', needed by 'build/libSDL.la'.  Stop.
  postPatch = "patchShebangs ./configure";

  outputs = [ "out" "dev" ];
  outputBin = "dev"; # sdl-config

  nativeBuildInputs = [ pkg-config ]
    ++ optional stdenv.isLinux libcap;

  propagatedBuildInputs = [ libiconv ] ++ extraPropagatedBuildInputs;

  buildInputs = [ ]
    ++ optional (!stdenv.hostPlatform.isMinGW && alsaSupport) audiofile
    ++ optionals stdenv.isDarwin [ AudioUnit CoreAudio CoreServices Kernel OpenGL ];

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
  ] ++ optional stdenv.isDarwin "--disable-x11-shared"
    ++ optional (!x11Support) "--without-x"
    ++ optional alsaSupport "--with-alsa-prefix=${alsa-lib.out}/lib";

  patches = [
    ./find-headers.patch

    # Fix window resizing issues, e.g. for xmonad
    # Ticket: http://bugzilla.libsdl.org/show_bug.cgi?id=1430
    (fetchpatch {
      name = "fix_window_resizing.diff";
      url = "https://bugs.debian.org/cgi-bin/bugreport.cgi?msg=10;filename=fix_window_resizing.diff;att=2;bug=665779";
      sha256 = "1z35azc73vvi19pzi6byck31132a8w1vzrghp1x3hy4a4f9z4gc6";
    })
    # Fix drops of keyboard events for SDL_EnableUNICODE
    (fetchpatch {
      url = "https://github.com/libsdl-org/SDL-1.2/commit/0332e2bb18dc68d6892c3b653b2547afe323854b.patch";
      sha256 = "0g458iv6pp9sikdch6ms8svz60lf5ks2q5wgid8s9rydhk98lpp5";
    })
    # Ignore insane joystick axis events
    (fetchpatch {
      url = "https://github.com/libsdl-org/SDL-1.2/commit/ab99cc82b0a898ad528d46fa128b649a220a94f4.patch";
      sha256 = "1b3473sawfdbkkxaqf1hg0vn37yk8hf655jhnjwdk296z4gclazh";
    })
    # https://bugzilla.libsdl.org/show_bug.cgi?id=1769
    (fetchpatch {
      url = "https://github.com/libsdl-org/SDL-1.2/commit/5d79977ec7a6b58afa6e4817035aaaba186f7e9f.patch";
      sha256 = "1k7y57b1zy5afib1g7w3in36n8cswbcrzdbrjpn5cb105rnb9vmp";
    })
    # Workaround X11 bug to allow changing gamma
    # Ticket: https://bugs.freedesktop.org/show_bug.cgi?id=27222
    (fetchpatch {
      name = "SDL_SetGamma.patch";
      url = "https://src.fedoraproject.org/cgit/rpms/SDL.git/plain/SDL-1.2.15-x11-Bypass-SetGammaRamp-when-changing-gamma.patch?id=04a3a7b1bd88c2d5502292fad27e0e02d084698d";
      sha256 = "0x52s4328kilyq43i7psqkqg7chsfwh0aawr50j566nzd7j51dlv";
    })
    # Fix a build failure on OS X Mavericks
    # Ticket: https://bugzilla.libsdl.org/show_bug.cgi?id=2085
    (fetchpatch {
      url = "https://github.com/libsdl-org/SDL-1.2/commit/19039324be71738d8990e91b9ba341b2ea068445.patch";
      sha256 = "0ckwling2ad27c9vxgp97ndjd098d6zbrydza8b9l77k8airj98c";
    })
    (fetchpatch {
      url = "https://github.com/libsdl-org/SDL-1.2/commit/7933032ad4d57c24f2230db29f67eb7d21bb5654.patch";
      sha256 = "1by16firaxyr0hjvn35whsgcmq6bl0nwhnpjf75grjzsw9qvwyia";
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
    homepage    = "http://www.libsdl.org/";
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
    license     = licenses.lgpl21;
  };
}
