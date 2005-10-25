{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cracklib-2.8.5";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/cracklib/cracklib-2.8.5.tar.gz;
    md5 = "68674db41be7569099b7aa287719b248";
  };
  dicts = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/cracklib/cracklib-words.gz;
    md5 = "d18e670e5df560a8745e1b4dede8f84f";
  };
}
