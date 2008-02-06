args: with args;

stdenv.mkDerivation {
  name = "ffmpeg-svn-2007-12-04";
  src = fetchsvn {
    url = svn://svn.mplayerhq.hu/ffmpeg/trunk ;
    rev = "11164";
    sha256 = "80d3b3311abaf8343b73c711f02d269e8c87991f2c3d0f08e32309d39ad6aa3b";
  };

  propagatedBuildInputs = [ a52dec lame libtheora x11 zlib SDL];
  # !!! Hm, what are the legal consequences of --enable-gpl?
  configureFlags = "--enable-pthreads --enable-gpl --enable-pp --enable-shared
  --disable-static --enable-x11grab  --enable-liba52 --enable-libmp3lame
  --enable-libtheora --enable-swscaler";
}

