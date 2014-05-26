{ stdenv, fetchurl, config, pkgconfig, yasm, zlib, bzip2, alsaLib, texinfo, perl
, lame, speex, libass, libtheora, libvorbis, libvpx, x264, xvidcore, libopus
, libvdpau, libva, faac, libdc1394, libXext, libXfixes, SDL
, freetype, fontconfig, fdk_aac, gnutls
}:

stdenv.mkDerivation rec {
  name = "ffmpeg-2.2.2";

  src = fetchurl {
    url = "http://www.ffmpeg.org/releases/${name}.tar.bz2";
    sha256 = "062jn47sm1ifwswcd3lx47nff62rgcwp84964q0v983issnrfax4";
  };

  subtitleSupport = config.ffmpeg.subtitle or true;
  mp3Support = config.ffmpeg.mp3 or true;
  speexSupport = config.ffmpeg.speex or true;
  theoraSupport = config.ffmpeg.theora or true;
  vorbisSupport = config.ffmpeg.vorbis or true;
  vpxSupport = config.ffmpeg.vpx or true;
  x264Support = config.ffmpeg.x264 or true;
  xvidSupport = config.ffmpeg.xvid or true;
  opusSupport = config.ffmpeg.opus or true;
  vdpauSupport = config.ffmpeg.vdpau or true;
  vaapiSupport = config.ffmpeg.vaapi or true;
  faacSupport = config.ffmpeg.faac or false;
  fdkAACSupport = config.ffmpeg.fdk or false;
  dc1394Support = config.ffmpeg.dc1394 or false;
  x11grabSupport = config.ffmpeg.x11grab or false;
  playSupport = config.ffmpeg.play or true;
  freetypeSupport = config.ffmpeg.freetype or true;
  gnutlsSupport = config.ffmpeg.gnutls or true;

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
    ++ stdenv.lib.optional (!stdenv.isDarwin && subtitleSupport) "--enable-libass"
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
    ++ stdenv.lib.optional (!stdenv.isDarwin && playSupport) "--enable-ffplay"
    ++ stdenv.lib.optional freetypeSupport "--enable-libfreetype --enable-fontconfig"
    ++ stdenv.lib.optional fdkAACSupport "--enable-libfdk_aac --enable-nonfree"
    ++ stdenv.lib.optional gnutlsSupport "--enable-gnutls";

  buildInputs = [ pkgconfig lame yasm zlib bzip2 texinfo perl ]
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
    ++ stdenv.lib.optional (!stdenv.isDarwin && playSupport) SDL
    ++ stdenv.lib.optionals freetypeSupport [ freetype fontconfig ]
    ++ stdenv.lib.optional fdkAACSupport fdk_aac
    ++ stdenv.lib.optional gnutlsSupport gnutls
    ++ stdenv.lib.optional (!stdenv.isDarwin && subtitleSupport) libass
    ++ stdenv.lib.optional (!stdenv.isDarwin) alsaLib;

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
    license = if (fdkAACSupport || faacSupport) then stdenv.lib.licenses.unfree else stdenv.lib.licenses.gpl2Plus;
  };
}
