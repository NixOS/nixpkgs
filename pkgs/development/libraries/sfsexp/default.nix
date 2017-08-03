{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "sfsexp-${version}";
  version = "1.3";

  src = fetchurl {
    url = "mirror://sourceforge/sexpr/sexpr-${version}.tar.gz";
    sha256 = "18gdwxjja0ip378hlzs8sp7q2g6hrmy7x10yf2wnxfmmylbpqn8k";
  };

  meta = with stdenv.lib; {
    description = "Small, fast s-expression library";
    homepage = http://sexpr.sourceforge.net/;
    maintainers = with maintainers; [ jb55 ];
    license = licenses.gpl3;
    platforms = with platforms; unix;
  };
}
