{ stdenv, fetchurl, pkgconfig, udev }:

stdenv.mkDerivation rec {
  name = "libserialport-0.1.1";

  src = fetchurl {
    url = "http://sigrok.org/download/source/libserialport/${name}.tar.gz";
    sha256 = "17ajlwgvyyrap8z7f16zcs59pksvncwbmd3mzf98wj7zqgczjaja";
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
