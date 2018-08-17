{ stdenv, fetchurl }:

let
  version = "2.31.1";
in
stdenv.mkDerivation {
  name = "avr-binutils-${version}";

  src = fetchurl {
    url = "mirror://gnu/binutils/binutils-${version}.tar.bz2";
    sha256 = "1l34hn1zkmhr1wcrgf0d4z7r3najxnw3cx2y2fk7v55zjlk3ik7z";
  };
  configureFlags = [ "--target=avr" "--enable-languages=c,c++" ];

  meta = with stdenv.lib; {
    description = "the GNU Binutils for AVR microcontrollers";
    homepage = http://www.gnu.org/software/binutils/;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mguentner ];
  };
}
