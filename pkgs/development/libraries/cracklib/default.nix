{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cracklib-2.8.5";
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/cracklib/cracklib-2.8.5.tar.gz;
    md5 = "68674db41be7569099b7aa287719b248";
  };
}
