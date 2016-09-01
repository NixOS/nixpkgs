{ stdenv, fetchurl, pkgconfig, libusb1 }:

stdenv.mkDerivation rec {
  name = "libmtp-1.1.11";

  src = fetchurl {
    url = "mirror://sourceforge/libmtp/${name}.tar.gz";
    sha256 = "1sc768q2cixwanlwrz95mp389iaadl4s95486caavxx4g7znvn8m";
  };

  outputs = [ "bin" "dev" "out" ];

  propagatedBuildInputs = [ libusb1 ];
  buildInputs = [ pkgconfig ];

  # tried to install files to /lib/udev, hopefully OK
  configureFlags = [ "--with-udev=$$bin/lib/udev" ];

  meta = {
    homepage = http://libmtp.sourceforge.net;
    description = "An implementation of Microsoft's Media Transfer Protocol";
    longDescription = ''
      libmtp is an implementation of Microsoft's Media Transfer Protocol (MTP)
      in the form of a library suitable primarily for POSIX compliant operating
      systems. We implement MTP Basic, the stuff proposed for standardization.
      '';
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
