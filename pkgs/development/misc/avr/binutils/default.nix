{ stdenv, fetchurl }:

let
  version = "2.31";
in
stdenv.mkDerivation {
  name = "avr-binutils-${version}";

  src = fetchurl {
    url = "mirror://gnu/binutils/binutils-${version}.tar.bz2";
    sha256 = "06gyiz6jzqqsp211z9xihnzzkjl138hlzqxr642r1f563imm6j9c";
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
