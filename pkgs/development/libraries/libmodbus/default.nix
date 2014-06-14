{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libmodbus-3.0.6";

  src = fetchurl {
    url = "http://libmodbus.org/releases/${name}.tar.gz";
    sha256 = "1dkijjv3dq0c5vc5z5f1awm8dlssbwg6ivsnvih22pkm1zqn6v84";
  };

  meta = with stdenv.lib; {
    description = "Library to send/receive data according to the Modbus protocol";
    homepage = http://libmodbus.org/;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
