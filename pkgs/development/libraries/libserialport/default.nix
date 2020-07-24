{ stdenv, fetchurl, pkgconfig, udev, darwin }:

stdenv.mkDerivation rec {
  name = "libserialport-0.1.1";

  src = fetchurl {
    url = "https://sigrok.org/download/source/libserialport/${name}.tar.gz";
    sha256 = "17ajlwgvyyrap8z7f16zcs59pksvncwbmd3mzf98wj7zqgczjaja";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = stdenv.lib.optional stdenv.isLinux udev
    ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.IOKit;

  meta = with stdenv.lib; {
    description = "Cross-platform shared library for serial port access";
    homepage = "https://sigrok.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.bjornfor ];
  };
}
