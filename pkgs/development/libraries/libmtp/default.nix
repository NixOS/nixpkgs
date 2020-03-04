{ stdenv, fetchurl, pkgconfig, libusb1, libiconv }:

stdenv.mkDerivation rec {
  name = "libmtp-1.1.17";

  src = fetchurl {
    url = "mirror://sourceforge/libmtp/${name}.tar.gz";
    sha256 = "1p3r38nvdip40ab1h4scj3mzfjkx6kd14szjqyw9r6wz5pslr8zq";
  };

  outputs = [ "bin" "dev" "out" ];

  buildInputs = [ libiconv ];
  propagatedBuildInputs = [ libusb1 ];
  nativeBuildInputs = [ pkgconfig ];

  # tried to install files to /lib/udev, hopefully OK
  configureFlags = [ "--with-udev=$$bin/lib/udev" ];

  meta = with stdenv.lib; {
    homepage = http://libmtp.sourceforge.net;
    description = "An implementation of Microsoft's Media Transfer Protocol";
    longDescription = ''
      libmtp is an implementation of Microsoft's Media Transfer Protocol (MTP)
      in the form of a library suitable primarily for POSIX compliant operating
      systems. We implement MTP Basic, the stuff proposed for standardization.
      '';
    platforms = platforms.unix;
    license = licenses.lgpl21;
  };
}
