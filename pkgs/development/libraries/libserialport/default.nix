{ stdenv, fetchurl, pkgconfig, udev }:

stdenv.mkDerivation rec {
  name = "libserialport-0.1.0";

  src = fetchurl {
    url = "http://sigrok.org/download/source/libserialport/${name}.tar.gz";
    sha256 = "1bqrldwrcsv6jbq3pmqczq27gdkrzpaxwplanqs25f6q9gb5p47c";
  };

  buildInputs = [ pkgconfig udev ];

  meta = with stdenv.lib; {
    description = "Cross-platform shared library for serial port access";
    homepage = http://sigrok.org/;
    license = licenses.gpl3Plus;
    # Mac OS X, Windows and Android is also supported (according to upstream).
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
