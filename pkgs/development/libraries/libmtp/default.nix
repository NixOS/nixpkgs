{ stdenv, fetchurl, pkgconfig, libusb1 }:

stdenv.mkDerivation rec {
  name = "libmtp-1.1.6";

  propagatedBuildInputs = [ libusb1 ];
  buildInputs = [ pkgconfig ];

  # tried to install files to /lib/udev, hopefully OK
  configureFlags = [ "--with-udev=$$out/lib/udev" ];

  src = fetchurl {
    url = "mirror://sourceforge/libmtp/${name}.tar.gz";
    sha256 = "02nbf1cigxmv9sak201f4m5c1d21q6avgzjlxd941plimy1iq71s";
  };

  meta = {
    homepage = http://libmtp.sourceforge.net;
    description = "An implementation of Microsoft's Media Transfer Protocol";
    longDescription = ''
      libmtp is an implementation of Microsoft's Media Transfer Protocol (MTP)
      in the form of a library suitable primarily for POSIX compliant operating
      systems. We implement MTP Basic, the stuff proposed for standardization.
      '';
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
