{ stdenv, fetchurl, pkgconfig, libusb1 }:

# TODO: add VXI development files, for VXI-11 (TCPIP) support

stdenv.mkDerivation rec {
  name = "librevisa-0.0.20130412";

  src = fetchurl {
    url = "http://www.librevisa.org/download/${name}.tar.gz";
    sha256 = "0bjzq23s3xzw0l9qx4l8achrx5id8xdd6r52lvdl4a28dxzbcfhq";
  };

  buildInputs = [ pkgconfig libusb1 ];

  meta = with stdenv.lib; {
    description = "Implementation of the VISA standard (for instrument control)";
    longDescription = ''
      LibreVISA aims to be a compliant implementation of the VISA standard in a
      free software library.

      We currently support targets connected via USB, exposing the USBTMC
      interface, and VXI-11 devices.
    '';
    homepage = http://www.librevisa.org/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
