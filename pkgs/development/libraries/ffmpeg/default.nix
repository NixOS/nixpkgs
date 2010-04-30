{stdenv, fetchurl, faad2, libtheora, speex, libvorbis, x264, pkgconfig, xvidcore}:

stdenv.mkDerivation {
  name = "ffmpeg-0.5.1";
  
  src = fetchurl {
    url = http://www.ffmpeg.org/releases/ffmpeg-0.5.1.tar.bz2;
    sha256 = "0n68lihyy3jk4q7f22kv6nranfbafyl41hnzpa6cm0r0vf473gn2";
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
  '';

  buildInputs = [faad2 libtheora speex libvorbis x264 pkgconfig xvidcore];

  meta = {
    homepage = http://www.ffmpeg.org/;
    description = "A complete, cross-platform solution to record, convert and stream audio and video";
  };
}
