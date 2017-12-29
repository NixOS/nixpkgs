{ stdenv, fetchurl }:

let
  version = "2.26";
in
stdenv.mkDerivation {
  name = "avr-binutils-${version}";

  src = fetchurl {
    url = "mirror://gnu/binutils/binutils-${version}.tar.bz2";
    sha256 = "1ngc2h3knhiw8s22l8y6afycfaxr5grviqy7mwvm4bsl14cf9b62";
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
