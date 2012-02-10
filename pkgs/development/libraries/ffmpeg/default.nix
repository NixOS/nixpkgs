{ stdenv, fetchurl, pkgconfig, yasm, zlib, bzip2
, mp3Support ? true, lame ? null
, speexSupport ? true, speex ? null
, theoraSupport ? true, libtheora ? null
, vorbisSupport ? true, libvorbis ? null
, vpxSupport ? false, libvpx ? null
, x264Support ? true, x264 ? null
, xvidSupport ? true, xvidcore ? null
, faacSupport ? false, faac ? null
}:

assert speexSupport -> speex != null;
assert theoraSupport -> libtheora != null;
assert vorbisSupport -> libvorbis != null;
assert vpxSupport -> libvpx != null;
assert x264Support -> x264 != null;
assert xvidSupport -> xvidcore != null;
assert faacSupport -> faac != null;

stdenv.mkDerivation rec {
  name = "ffmpeg-0.10";
  
  src = fetchurl {
    url = "http://www.ffmpeg.org/releases/${name}.tar.bz2";
    sha256 = "1ybzw6d5axr807141izvm2yf4pa0hc1zcywj89nsn3qsdnknlna3";
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

  buildInputs = [ pkgconfig lame yasm zlib bzip2 ]
    ++ stdenv.lib.optional mp3Support lame
    ++ stdenv.lib.optional speexSupport speex
    ++ stdenv.lib.optional theoraSupport libtheora
    ++ stdenv.lib.optional vorbisSupport libvorbis
    ++ stdenv.lib.optional vpxSupport libvpx
    ++ stdenv.lib.optional x264Support x264
    ++ stdenv.lib.optional xvidSupport xvidcore
    ++ stdenv.lib.optional faacSupport faac;

  enableParallelBuilding = true;
    
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
    homepage = http://www.ffmpeg.org/;
    description = "A complete, cross-platform solution to record, convert and stream audio and video";
  };
}
