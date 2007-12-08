{stdenv, fetchsvn}:

stdenv.mkDerivation {
  name = "ffmpeg-svn-2007-12-04";
  src = fetchsvn {
    url = svn://svn.mplayerhq.hu/ffmpeg/trunk ;
    rev = "11164";
    sha256 = "95658455e466aeab5a302ddd6e7b2f79f620d4495012add46028a548e6c364b2";
  };
  /*fetchurl {
    url = http://ffmpeg.mplayerhq.hu/ffmpeg-export-snapshot.tar.bz2;
    sha256 = "040a35f0c004323af14329c09ad3cff8d040e2cf9797d97cde3d9d83d02b4d87";
  };*/
  # !!! Hm, what are the legal consequences of --enable-gpl?
  configureFlags = "--enable-shared --enable-pp --enable-gpl --disable-ffserver --disable-ffplay";
}
