{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "ffmpeg-svn";
  src = fetchurl {
    url = http://ffmpeg.mplayerhq.hu/ffmpeg-export-snapshot.tar.bz2;
    sha256 = "040a35f0c004323af14329c09ad3cff8d040e2cf9797d97cde3d9d83d02b4d87";
  };
  # !!! Hm, what are the legal consequences of --enable-gpl?
  configureFlags = "--enable-shared --enable-pp --enable-gpl --disable-ffserver --disable-ffplay";
}
