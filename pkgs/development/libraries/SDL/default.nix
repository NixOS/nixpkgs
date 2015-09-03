{ stdenv, fetchurl, pkgconfig, audiofile, libcap
, openglSupport ? false, mesa ? null
, alsaSupport ? true, alsaLib ? null
, x11Support ? true, x11 ? null, libXrandr ? null
, pulseaudioSupport ? true, libpulseaudio ? null
}:

# OSS is no longer supported, for it's much crappier than ALSA and
# PulseAudio.
assert (stdenv.isLinux && !(stdenv ? cross)) -> alsaSupport || pulseaudioSupport;

assert openglSupport -> (mesa != null && x11Support);
assert x11Support -> (x11 != null && libXrandr != null);
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

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ pkgconfig ];

  # Since `libpulse*.la' contain `-lgdbm', PulseAudio must be propagated.
  propagatedBuildInputs =
    optionals x11Support [ x11 libXrandr ] ++
    optional alsaSupport alsaLib ++
    optional stdenv.isLinux libcap ++
    optional openglSupport mesa ++
    optional pulseaudioSupport libpulseaudio;

  buildInputs = let
    notMingw = !(stdenv ? cross) || stdenv.cross.libc != "msvcrt";
  in optional notMingw audiofile;

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
  ] ++ stdenv.lib.optional alsaSupport "--with-alsa-prefix=${alsaLib}/lib");

  # Fix a build failure on OS X Mavericks
  # Ticket: https://bugzilla.libsdl.org/show_bug.cgi?id=2085
  patches = stdenv.lib.optional stdenv.isDarwin [ (fetchurl {
    url = "http://bugzilla-attachments.libsdl.org/attachment.cgi?id=1320";
    sha1 = "3137feb503a89a8d606405373905b92dcf7e293b";
  }) ];

  crossAttrs =stdenv.lib.optionalAttrs (stdenv.cross.libc == "libSystem") {
    patches = let
      f = rev: sha256: fetchurl {
        url = "http://hg.libsdl.org/SDL/raw-rev/${rev}";
        inherit sha256;
      };
    in [
      (f "e9466ead70e5" "0ygir3k83d0vxp7s3k48jn3j8n2bnv9wm6613wpx3ybnjrxabrip")
      (f "bbfb41c13a87" "17v29ybjifvka19m8qf14rjc43nfdwk9v9inaizznarhb17amlnv")
    ];
    postPatch = ''
      sed -i -e 's/ *-fpascal-strings//' configure
    '';
  };

  passthru = {inherit openglSupport;};

  meta = with stdenv.lib; {
    description = "A cross-platform multimedia library";
    homepage    = http://www.libsdl.org/;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
