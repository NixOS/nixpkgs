{ stdenv, fetchurl, fetchpatch, pkgconfig, audiofile, libcap
, openglSupport ? false, mesa ? null
, alsaSupport ? true, alsaLib ? null
, x11Support ? true, xlibsWrapper ? null, libXrandr ? null
, pulseaudioSupport ? true, libpulseaudio ? null
, OpenGL, CoreAudio, CoreServices, AudioUnit, Kernel, Cocoa
}:

# OSS is no longer supported, for it's much crappier than ALSA and
# PulseAudio.
assert (stdenv.isLinux && !(stdenv ? cross)) -> alsaSupport || pulseaudioSupport;

assert openglSupport -> (mesa != null && x11Support);
assert x11Support -> (xlibsWrapper != null && libXrandr != null);
assert alsaSupport -> alsaLib != null;
assert pulseaudioSupport -> libpulseaudio != null;

let
  inherit (stdenv.lib) optional optionals;
in
stdenv.mkDerivation rec {
  version = "1.2.15";
  name    = "SDL-${version}";

  src = fetchurl {
    url    = "http://www.libsdl.org/release/${name}.tar.gz";
    sha256 = "005d993xcac8236fpvd1iawkz4wqjybkpn8dbwaliqz5jfkidlyn";
  };

  outputs = [ "dev" "out" ];
  outputBin = "dev"; # sdl-config

  nativeBuildInputs = [ pkgconfig ];

  # Since `libpulse*.la' contain `-lgdbm', PulseAudio must be propagated.
  propagatedBuildInputs =
    optionals x11Support [ xlibsWrapper libXrandr ] ++
    optional alsaSupport alsaLib ++
    optional stdenv.isLinux libcap ++
    optional openglSupport mesa ++
    optional pulseaudioSupport libpulseaudio ++
    optional stdenv.isDarwin Cocoa;

  buildInputs = let
    notMingw = !(stdenv ? cross) || stdenv.cross.libc != "msvcrt";
  in optional notMingw audiofile
  ++ optionals stdenv.isDarwin [ OpenGL CoreAudio CoreServices AudioUnit Kernel ];

  # XXX: By default, SDL wants to dlopen() PulseAudio, in which case
  # we must arrange to add it to its RPATH; however, `patchelf' seems
  # to fail at doing this, hence `--disable-pulseaudio-shared'.
  configureFlags = [
    "--disable-oss"
    "--disable-video-x11-xme"
    "--disable-x11-shared"
    "--disable-alsa-shared"
    "--enable-rpath"
    "--disable-pulseaudio-shared"
    "--disable-osmesa-shared"
  ] ++ stdenv.lib.optionals (stdenv ? cross) ([
    "--without-x"
  ] ++ stdenv.lib.optional alsaSupport "--with-alsa-prefix=${alsaLib.out}/lib");

  patches = [
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
    # Workaround X11 bug to allow changing gamma
    # Ticket: https://bugs.freedesktop.org/show_bug.cgi?id=27222
    (fetchpatch {
      url = "http://pkgs.fedoraproject.org/cgit/rpms/SDL.git/plain/SDL-1.2.15-x11-Bypass-SetGammaRamp-when-changing-gamma.patch?id=04a3a7b1bd88c2d5502292fad27e0e02d084698d";
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

  postFixup = ''moveToOutput share/aclocal "$dev" '';

  passthru = { inherit openglSupport; };

  meta = with stdenv.lib; {
    description = "A cross-platform multimedia library";
    homepage    = http://www.libsdl.org/;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
    license     = licenses.lgpl21;
  };
}
