{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "mpeg2dec-20050802";
  src = fetchurl {
    url = ftp://ftp.u-strasbg.fr/pub/videolan/vlc/0.8.4a/contrib/mpeg2dec-20050802.tar.gz;
    md5 = "79b3559a9354085fcebb1460dd93d237";
  };
}
