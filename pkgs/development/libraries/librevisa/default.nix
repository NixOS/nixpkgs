{ lib, stdenv, fetchurl, pkg-config, libusb1 }:

# TODO: add VXI development files, for VXI-11 (TCPIP) support

stdenv.mkDerivation rec {
  pname = "librevisa";
  version = "0.0.20130412";

  src = fetchurl {
    url = "http://www.librevisa.org/download/${pname}-${version}.tar.gz";
    sha256 = "0bjzq23s3xzw0l9qx4l8achrx5id8xdd6r52lvdl4a28dxzbcfhq";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ];

  meta = with lib; {
    description = "Implementation of the VISA standard (for instrument control)";
    longDescription = ''
      LibreVISA aims to be a compliant implementation of the VISA standard in a
      free software library.

      We currently support targets connected via USB, exposing the USBTMC
      interface, and VXI-11 devices.
    '';
    homepage = "http://www.librevisa.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.bjornfor ];
  };
}
