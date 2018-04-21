{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libmodbus-3.1.4";

  src = fetchurl {
    url = "http://libmodbus.org/releases/${name}.tar.gz";
    sha256 = "0drnil8bzd4n4qb0wv3ilm9zvypxvwmzd65w96d6kfm7x6q65j68";
  };

  meta = with stdenv.lib; {
    description = "Library to send/receive data according to the Modbus protocol";
    homepage = http://libmodbus.org/;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
