{ stdenv, fetchurl }:

let
  version = "2.30";
in
stdenv.mkDerivation {
  name = "avr-binutils-${version}";

  src = fetchurl {
    url = "mirror://gnu/binutils/binutils-${version}.tar.bz2";
    sha256 = "028cklfqaab24glva1ks2aqa1zxa6w6xmc8q34zs1sb7h22dxspg";
  };
  configureFlags = "--target=avr --enable-languages=c,c++";

  meta = with stdenv.lib; {
    description = "the GNU Binutils for AVR microcontrollers";
    homepage = http://www.gnu.org/software/binutils/;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mguentner ];
  };
}
