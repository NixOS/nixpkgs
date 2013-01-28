{ stdenv, fetchurl, pkgconfig, yasm, zlib, bzip2, alsaLib
, mp3Support ? true, lame ? null
, speexSupport ? true, speex ? null
, theoraSupport ? true, libtheora ? null
, vorbisSupport ? true, libvorbis ? null
, vpxSupport ? false, libvpx ? null
, x264Support ? true, x264 ? null
, xvidSupport ? true, xvidcore ? null
, vdpauSupport ? true, libvdpau ? null
, faacSupport ? false, faac ? null
, dc1394Support ? false, libdc1394 ? null
, x11grabSupport ? false, libXext ? null, libXfixes ? null
}:

assert speexSupport -> speex != null;
assert theoraSupport -> libtheora != null;
assert vorbisSupport -> libvorbis != null;
assert vpxSupport -> libvpx != null;
assert x264Support -> x264 != null;
assert xvidSupport -> xvidcore != null;
assert vdpauSupport -> libvdpau != null;
assert faacSupport -> faac != null;
assert x11grabSupport -> libXext != null && libXfixes != null;

stdenv.mkDerivation rec {
  name = "ffmpeg-1.1";
  
  src = fetchurl {
    url = "http://www.ffmpeg.org/releases/${name}.tar.bz2";
    sha256 = "03s1zsprz5p6gjgwwqcf7b6cvzwwid6l8k7bamx9i0f1iwkgdm0j";
  };
  
  # `--enable-gpl' (as well as the `postproc' and `swscale') mean that
  # the resulting library is GPL'ed, so it can only be used in GPL'ed
  # applications.
  configureFlags = [
    "--enable-gpl"
    "--enable-postproc"
    "--enable-swscale"
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
    ++ stdenv.lib.optional vdpauSupport "--enable-vdpau"
    ++ stdenv.lib.optional faacSupport "--enable-libfaac --enable-nonfree"
    ++ stdenv.lib.optional dc1394Support "--enable-libdc1394"
    ++ stdenv.lib.optional x11grabSupport "--enable-x11grab";

  buildInputs = [ pkgconfig lame yasm zlib bzip2 alsaLib ]
    ++ stdenv.lib.optional mp3Support lame
    ++ stdenv.lib.optional speexSupport speex
    ++ stdenv.lib.optional theoraSupport libtheora
    ++ stdenv.lib.optional vorbisSupport libvorbis
    ++ stdenv.lib.optional vpxSupport libvpx
    ++ stdenv.lib.optional x264Support x264
    ++ stdenv.lib.optional xvidSupport xvidcore
    ++ stdenv.lib.optional vdpauSupport libvdpau
    ++ stdenv.lib.optional faacSupport faac
    ++ stdenv.lib.optional dc1394Support libdc1394
    ++ stdenv.lib.optionals x11grabSupport [ libXext libXfixes ];

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
