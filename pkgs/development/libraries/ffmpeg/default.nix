{stdenv, fetchurl, faad2}:

stdenv.mkDerivation {
  name = "ffmpeg-0.5";
  
  src = fetchurl {
    url = http://www.ffmpeg.org/releases/ffmpeg-0.5.tar.bz2;
    sha1 = "f930971bc0ac3d11a4ffbb1af439425c24f6f5b1";
  };
  
  # `--enable-gpl' (as well as the `postproc' and `swscale') mean that
  # the resulting library is GPL'ed, so it can only be used in GPL'ed
  # applications.
  configureFlags = ''
    --enable-shared
    --disable-static
    --enable-gpl
    --enable-postproc
    --enable-swscale
    --disable-ffserver
    --disable-ffplay
    --enable-libfaad
  '';

  buildInputs = [faad2];

  meta = {
    homepage = http://www.ffmpeg.org/;
    description = "A complete, cross-platform solution to record, convert and stream audio and video";
  };
}
