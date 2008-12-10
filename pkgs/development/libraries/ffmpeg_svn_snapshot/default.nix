{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "ffmpeg-svn-pre-r11901";
  src = fetchurl {
    url = http://nixos.org/tarballs/ffmpeg-svn-r11901.tar.bz2;
    sha256 = "0l5207gnfaz57pvlxpxyjphyz0mp9plnxzd0aghy0nz3hmqh4rs7";
  };
  # !!! Hm, what are the legal consequences of --enable-gpl?
  configureFlags = "--enable-shared --enable-pp --enable-gpl --disable-ffserver --disable-ffplay";
}
