args: with args;

stdenv.mkDerivation {
  name = "ffmpeg-svn-2007-12-04";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/ffmpeg-svn-r11901.tar.bz2;
    sha256 = "0l5207gnfaz57pvlxpxyjphyz0mp9plnxzd0aghy0nz3hmqh4rs7";
  };

  propagatedBuildInputs = [ a52dec lame libtheora x11 zlib SDL];
  # !!! Hm, what are the legal consequences of --enable-gpl?
  configureFlags = "--enable-pthreads --enable-gpl --enable-pp --enable-shared
  --disable-static --enable-x11grab  --enable-liba52 --enable-libmp3lame
  --enable-libtheora --enable-swscaler";
}

