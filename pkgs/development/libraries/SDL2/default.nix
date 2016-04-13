{ stdenv, fetchurl, pkgconfig, audiofile
, openglSupport ? false, mesa ? null
, alsaSupport ? true, alsaLib ? null
, x11Support ? true, xlibsWrapper ? null, libXrandr ? null
, pulseaudioSupport ? true, libpulseaudio ? null
, AudioUnit, Cocoa, CoreAudio, CoreServices, ForceFeedback, OpenGL
}:

# OSS is no longer supported, for it's much crappier than ALSA and
# PulseAudio.
assert !stdenv.isDarwin -> alsaSupport || pulseaudioSupport;

assert openglSupport -> (stdenv.isDarwin || mesa != null && x11Support);
assert x11Support -> (xlibsWrapper != null && libXrandr != null);
assert alsaSupport -> alsaLib != null;
assert pulseaudioSupport -> libpulseaudio != null;

let
  configureFlagsFun = attrs: ''
        --disable-oss --disable-x11-shared
        --disable-pulseaudio-shared --disable-alsa-shared
        ${if alsaSupport then "--with-alsa-prefix=${attrs.alsaLib}/lib" else ""}
        ${if (!x11Support) then "--without-x" else ""}
      '';
in
stdenv.mkDerivation rec {
  name = "SDL2-2.0.4";

  src = fetchurl {
    url = "http://www.libsdl.org/release/${name}.tar.gz";
    sha256 = "0jqp46mxxbh9lhpx1ih6sp93k752j2smhpc0ad0q4cb3px0famfs";
  };

  # Since `libpulse*.la' contain `-lgdbm', PulseAudio must be propagated.
  propagatedBuildInputs = stdenv.lib.optionals x11Support [ xlibsWrapper libXrandr ] ++
    stdenv.lib.optional pulseaudioSupport libpulseaudio;

  buildInputs = [ pkgconfig audiofile ] ++
    stdenv.lib.optional openglSupport mesa ++
    stdenv.lib.optional alsaSupport alsaLib ++
    stdenv.lib.optionals stdenv.isDarwin [ AudioUnit Cocoa CoreAudio CoreServices ForceFeedback OpenGL ];

  # https://bugzilla.libsdl.org/show_bug.cgi?id=1431
  dontDisableStatic = true;

  # XXX: By default, SDL wants to dlopen() PulseAudio, in which case
  # we must arrange to add it to its RPATH; however, `patchelf' seems
  # to fail at doing this, hence `--disable-pulseaudio-shared'.
  configureFlags = configureFlagsFun { inherit alsaLib; };

  crossAttrs = {
      configureFlags = configureFlagsFun { alsaLib = alsaLib.crossDrv; };
  };

  postInstall = ''
    rm $out/lib/*.a
  '';

  passthru = {inherit openglSupport;};

  meta = {
    description = "A cross-platform multimedia library";
    homepage = http://www.libsdl.org/;
    license = stdenv.lib.licenses.zlib;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.page ];
  };
}
