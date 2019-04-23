{ stdenv, config, libGLSupported, fetchurl, fetchpatch, pkgconfig, audiofile, libcap, libiconv
, openglSupport ? libGLSupported, libGL, libGLU
, alsaSupport ? stdenv.isLinux && !stdenv.hostPlatform.isAndroid, alsaLib
, x11Support ? !stdenv.isCygwin && !stdenv.hostPlatform.isAndroid
, libXext, libICE, libXrandr
, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux && !stdenv.hostPlatform.isAndroid, libpulseaudio
, OpenGL, CoreAudio, CoreServices, AudioUnit, Kernel, Cocoa
, cf-private
}:

# NOTE: When editing this expression see if the same change applies to
# SDL2 expression too

with stdenv.lib;

stdenv.mkDerivation rec {
  name    = "SDL-${version}";
  version = "1.2.15";

  src = fetchurl {
    url    = "https://www.libsdl.org/release/${name}.tar.gz";
    sha256 = "005d993xcac8236fpvd1iawkz4wqjybkpn8dbwaliqz5jfkidlyn";
  };

  # make: *** No rule to make target 'build/*.lo', needed by 'build/libSDL.la'.  Stop.
  postPatch = "patchShebangs ./configure";

  outputs = [ "out" "dev" ];
  outputBin = "dev"; # sdl-config

  nativeBuildInputs = [ pkgconfig ]
    ++ optional stdenv.isLinux libcap;

  propagatedBuildInputs = [ libiconv ]
    ++ optionals x11Support [ libXext libICE libXrandr ]
    ++ optionals openglSupport [ libGL libGLU ]
    ++ optional alsaSupport alsaLib
    ++ optional pulseaudioSupport libpulseaudio
    ++ optional stdenv.isDarwin Cocoa;

  buildInputs = [ ]
    ++ optional (!stdenv.hostPlatform.isMinGW && alsaSupport) audiofile
    ++ optionals stdenv.isDarwin [
      AudioUnit CoreAudio CoreServices Kernel OpenGL
      # Needed for NSDefaultRunLoopMode symbols.
      cf-private
    ];

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
    ++ optional alsaSupport "--with-alsa-prefix=${alsaLib.out}/lib";

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
      url = "http://hg.libsdl.org/SDL/raw-rev/0aade9c0203f";
      sha256 = "1y9izncjlqvk1mkz1pkl9lrk9s452cmg2izjjlqqrhbn8279xy50";
    })
    # Ignore insane joystick axis events
    (fetchpatch {
      url = "http://hg.libsdl.org/SDL/raw-rev/95abff7adcc2";
      sha256 = "0i8x0kx0pw12ld5bfxhyzs466y3c0n9dscw1ijhq1b96r72xyhqq";
    })
    # https://bugzilla.libsdl.org/show_bug.cgi?id=1769
    (fetchpatch {
      url = "http://hg.libsdl.org/SDL/raw-rev/91ad7b43317a";
      sha256 = "15g537vbl2my4mfrjxfkcx9ri6bk2gjvaqj650rjdxwk2nkdkn4b";
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
      url = "http://hg.libsdl.org/SDL/raw-rev/e9466ead70e5";
      sha256 = "0mpwdi09h89df2wxqw87m1rdz7pr46k0w6alk691k8kwv970z6pl";
    })
    (fetchpatch {
      url = "http://hg.libsdl.org/SDL/raw-rev/bbfb41c13a87";
      sha256 = "1336g7waaf1c8yhkz11xbs500h8bmvabh4h437ax8l1xdwcppfxv";
    })
  ];

  postInstall = ''
    moveToOutput share/aclocal "$dev"
  '';

  # See the same place in the expression for SDL2
  postFixup = ''
    for lib in $out/lib/*.so* ; do
      if [[ -L "$lib" ]]; then
        patchelf --set-rpath "$(patchelf --print-rpath $lib):${makeLibraryPath propagatedBuildInputs}" "$lib"
      fi
    done
  '';

  setupHook = ./setup-hook.sh;

  passthru = { inherit openglSupport; };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A cross-platform multimedia library";
    homepage    = "http://www.libsdl.org/";
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
    license     = licenses.lgpl21;
  };
}
