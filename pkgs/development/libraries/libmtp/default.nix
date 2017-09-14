{ stdenv, fetchurl, pkgconfig, libusb1 }:

stdenv.mkDerivation rec {
  name = "libmtp-1.1.13";

  src = fetchurl {
    url = "mirror://sourceforge/libmtp/${name}.tar.gz";
    sha256 = "0h3dv9py5mmvxhfxmkr8ky4s80hgq3d66cmrfnnnlcdwpwpy0kj9";
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
    maintainers = [ ];
  };
}
