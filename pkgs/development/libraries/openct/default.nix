{stdenv, fetchurl, libtool, pcsclite, libusb, pkgconfig}:

stdenv.mkDerivation rec {
  name = "openct-0.6.19";
  
  src = fetchurl {
    url = "http://www.opensc-project.org/files/openct/${name}.tar.gz";
    sha256 = "1y4jlr877g3lziq7i3p6pdkscqpkn1lld874q6r2hsvc39n7c88z";
  };
  
  configureFlags = [ "--enable-usb" "--enable-pcsc" ];
  buildInputs = [ libtool pcsclite libusb pkgconfig ];

  meta = {
    homepage = http://www.opensc-project.org/openct/;
    license = "LGPL";
    description = "Drivers for several smart card readers";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
