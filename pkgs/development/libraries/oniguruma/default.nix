{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "onig-5.9.5";

  src = fetchurl {
    url = http://www.geocities.jp/kosako3/oniguruma/archive/onig-5.9.5.tar.gz;
    sha256 = "12j3fsdb8hbhnj29hysal9l7i7s71l0ln3lx8hjpxx5535wawjcz";
  };

  meta = {
    homepage = http://www.geocities.jp/kosako3/oniguruma/;
    description = "Regular expressions library";
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
