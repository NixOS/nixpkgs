{ stdenv, fetchurl, pkgconfig, yasm, xz
, mp3Support ? true, lame ? null
, speexSupport ? true, speex ? null
, theoraSupport ? true, libtheora ? null
, vorbisSupport ? true, libvorbis ? null
, vpxSupport ? false, libvpx ? null
, x264Support ? false, x264 ? null
, xvidSupport ? true, xvidcore ? null
, faacSupport ? false, faac ? null
}:

assert speexSupport -> speex != null;
assert theoraSupport -> libtheora != null;
assert vorbisSupport -> libvorbis != null;
assert vpxSupport -> libvpx != null;
assert x264Support -> x264 != null;
assert xvidSupport -> xvidcore != null;

stdenv.mkDerivation rec {
  name = "libav-0.7";
  
  src = fetchurl {
    url = "http://libav.org/releases/${name}.tar.xz";
    sha256 = "04pl6y53xh6xmwzz0f12mg5vh62ylp5zwwinj6dxzd8pnbjg4lsz";
  };

  # `--enable-gpl' (as well as the `postproc' and `swscale') mean that
  # the resulting library is GPL'ed, so it can only be used in GPL'ed
  # applications.
  configureFlags = [
    "--enable-gpl"
    "--enable-postproc"
    "--enable-swscale"
    "--disable-ffserver"
    "--disable-ffplay"
    "--enable-shared"
    "--enable-runtime-cpudetect"
  ]
    ++ stdenv.lib.optional mp3Support "--enable-libmp3lame"
    ++ stdenv.lib.optional speexSupport "--enable-libspeex"
    ++ stdenv.lib.optional theoraSupport "--enable-libtheora"
    ++ stdenv.lib.optional vorbisSupport "--enable-libvorbis"
    ++ stdenv.lib.optional vpxSupport "--enable-libvpx"
    ++ stdenv.lib.optional x264Support "--enable-libx264"
    ++ stdenv.lib.optional xvidSupport "--enable-libxvid"
    ++ stdenv.lib.optional faacSupport "--enable-libfaac --enable-nonfree";

  buildInputs = [ pkgconfig lame yasm ]
    ++ stdenv.lib.optional mp3Support lame
    ++ stdenv.lib.optional speexSupport speex
    ++ stdenv.lib.optional theoraSupport libtheora
    ++ stdenv.lib.optional vorbisSupport libvorbis
    ++ stdenv.lib.optional vpxSupport libvpx
    ++ stdenv.lib.optional x264Support x264
    ++ stdenv.lib.optional xvidSupport xvidcore
    ++ stdenv.lib.optional faacSupport faac;

  crossAttrs = {
    dontSetConfigureCross = true;
    configureFlags = configureFlags ++ [
      "--cross-prefix=${stdenv.cross.config}-"
      "--enable-cross-compile"
      "--target_os=linux"
      "--arch=${stdenv.cross.arch}"
      ];
  };

  meta = {
    homepage = http://libav.org/;
    description = "A complete, cross-platform solution to record, convert and stream audio and video (fork of ffmpeg)";
  };
}
