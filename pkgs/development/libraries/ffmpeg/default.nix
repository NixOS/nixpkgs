{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "ffmpeg-20051126";
  src = fetchurl {
    url = http://downloads.videolan.org/pub/videolan/vlc/0.8.4a/contrib/ffmpeg-20051126.tar.bz2;
    md5 = "f9e50bf9ee1dd248a276bf9bd4d606e0";
  };
  # !!! Hm, what are the legal consequences of --enable-gpl?
  configureFlags = "--enable-shared --enable-pp --enable-shared-pp --enable-gpl --disable-ffserver --disable-ffplay";
}
