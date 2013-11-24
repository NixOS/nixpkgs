{ stdenv, fetchurl, pkgconfig, yasm, zlib, bzip2, alsaLib, texinfo, perl
, mp3Support ? true, lame ? null
, speexSupport ? true, speex ? null
, theoraSupport ? true, libtheora ? null
, vorbisSupport ? true, libvorbis ? null
, vpxSupport ? false, libvpx ? null
, x264Support ? true, x264 ? null
, xvidSupport ? true, xvidcore ? null
, opusSupport ? true, libopus ? null
, vdpauSupport ? true, libvdpau ? null
, vaapiSupport ? true, libva ? null
, faacSupport ? false, faac ? null
, dc1394Support ? false, libdc1394 ? null
, x11grabSupport ? false, libXext ? null, libXfixes ? null
, playSupport ? true, SDL ? null
, freetypeSupport ? true, freetype ? null
}:

assert speexSupport -> speex != null;
assert theoraSupport -> libtheora != null;
assert vorbisSupport -> libvorbis != null;
assert vpxSupport -> libvpx != null;
assert x264Support -> x264 != null;
assert xvidSupport -> xvidcore != null;
assert opusSupport -> libopus != null;
assert vdpauSupport -> libvdpau != null;
assert vaapiSupport -> libva != null;
assert faacSupport -> faac != null;
assert x11grabSupport -> libXext != null && libXfixes != null;
assert playSupport -> SDL != null;
assert freetypeSupport -> freetype != null;

stdenv.mkDerivation rec {
  name = "ffmpeg-1.2.3";

  src = fetchurl {
    url = "http://www.ffmpeg.org/releases/${name}.tar.bz2";
    sha256 = "0nvilgwaivzvikgp9lpvrwi4p1clxl4w8j961599bg0r2v7n4x6r";
  };

  # `--enable-gpl' (as well as the `postproc' and `swscale') mean that
  # the resulting library is GPL'ed, so it can only be used in GPL'ed
  # applications.
  configureFlags = [
    "--enable-gpl"
    "--enable-postproc"
    "--enable-swscale"
    "--enable-shared"
    "--enable-avresample"
    "--enable-runtime-cpudetect"
  ]
    ++ stdenv.lib.optional mp3Support "--enable-libmp3lame"
    ++ stdenv.lib.optional speexSupport "--enable-libspeex"
    ++ stdenv.lib.optional theoraSupport "--enable-libtheora"
    ++ stdenv.lib.optional vorbisSupport "--enable-libvorbis"
    ++ stdenv.lib.optional vpxSupport "--enable-libvpx"
    ++ stdenv.lib.optional x264Support "--enable-libx264"
    ++ stdenv.lib.optional xvidSupport "--enable-libxvid"
    ++ stdenv.lib.optional opusSupport "--enable-libopus"
    ++ stdenv.lib.optional vdpauSupport "--enable-vdpau"
    ++ stdenv.lib.optional faacSupport "--enable-libfaac --enable-nonfree"
    ++ stdenv.lib.optional dc1394Support "--enable-libdc1394"
    ++ stdenv.lib.optional x11grabSupport "--enable-x11grab"
    ++ stdenv.lib.optional playSupport "--enable-ffplay"
    ++ stdenv.lib.optional freetypeSupport "--enable-libfreetype";

  buildInputs = [ pkgconfig lame yasm zlib bzip2 alsaLib texinfo perl ]
    ++ stdenv.lib.optional mp3Support lame
    ++ stdenv.lib.optional speexSupport speex
    ++ stdenv.lib.optional theoraSupport libtheora
    ++ stdenv.lib.optional vorbisSupport libvorbis
    ++ stdenv.lib.optional vpxSupport libvpx
    ++ stdenv.lib.optional x264Support x264
    ++ stdenv.lib.optional xvidSupport xvidcore
    ++ stdenv.lib.optional opusSupport libopus
    ++ stdenv.lib.optional vdpauSupport libvdpau
    ++ stdenv.lib.optional vaapiSupport libva
    ++ stdenv.lib.optional faacSupport faac
    ++ stdenv.lib.optional dc1394Support libdc1394
    ++ stdenv.lib.optionals x11grabSupport [ libXext libXfixes ]
    ++ stdenv.lib.optional playSupport SDL
    ++ stdenv.lib.optional freetypeSupport freetype;

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

  passthru = {
    inherit vdpauSupport;
  };

  meta = {
    homepage = http://www.ffmpeg.org/;
    description = "A complete, cross-platform solution to record, convert and stream audio and video";
  };
}
