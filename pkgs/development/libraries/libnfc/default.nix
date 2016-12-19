{ stdenv, fetchurl, libusb }:

stdenv.mkDerivation rec {
  name = "libnfc-${version}";
  version = "1.7.1";

  src = fetchurl {
    url = "http://dl.bintray.com/nfc-tools/sources/libnfc-1.7.1.tar.bz2";
    sha256 = "0wj0iwwcpmpalyk61aa7yc6i4p9hgdajkrgnlswgk0vnwbc78pll";
  };

  buildInputs = [ libusb ];

  meta = with stdenv.lib; {
    description = "Open source library libnfc for Near Field Communication";
    license = licenses.gpl3;
    homepage = http://code.google.com/p/libnfc/;
    maintainers = with maintainers; [offline];
    platforms = platforms.unix;
  };
}
