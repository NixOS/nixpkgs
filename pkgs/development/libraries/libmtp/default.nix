{ stdenv, fetchurl, pkgconfig, libusb1 }:

stdenv.mkDerivation rec {
  name = "libmtp-1.1.14";

  src = fetchurl {
    url = "mirror://sourceforge/libmtp/${name}.tar.gz";
    sha256 = "1s0jyhypxmj0j8s003ba1n74x63h1rw8am9q4z2ip3xyjvid65rq";
  };

  outputs = [ "bin" "dev" "out" ];

  propagatedBuildInputs = [ libusb1 ];
  nativeBuildInputs = [ pkgconfig ];

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
    maintainers = [ ];
  };
}
