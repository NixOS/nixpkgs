{stdenv, fetchurl, faad2, libtheora, speex, libvorbis, x264, pkgconfig, xvidcore, lame, yasm
, libvpx}:

stdenv.mkDerivation {
  name = "ffmpeg-0.6";
  
  src = fetchurl {
    url = http://www.ffmpeg.org/releases/ffmpeg-0.6.tar.bz2;
    sha256 = "08419kg2i8j7x4mb3vm6a73fdszivj6lzh7lypxby30gfnkblc37";
  };
  
  # `--enable-gpl' (as well as the `postproc' and `swscale') mean that
  # the resulting library is GPL'ed, so it can only be used in GPL'ed
  # applications.
  configureFlags = ''
    --enable-gpl
    --enable-postproc
    --enable-swscale
    --disable-ffserver
    --disable-ffplay
    --enable-libfaad
    --enable-shared
    --enable-libtheora
    --enable-libvorbis
    --enable-libspeex
    --enable-libx264
    --enable-libxvid
    --enable-libmp3lame
    --enable-runtime-cpudetect
    --enable-libvpx
  '';

  buildInputs = [faad2 libtheora speex libvorbis x264 pkgconfig xvidcore lame yasm libvpx];

  meta = {
    homepage = http://www.ffmpeg.org/;
    description = "A complete, cross-platform solution to record, convert and stream audio and video";
  };
}
