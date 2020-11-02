{ stdenv, fetchurl, pkgconfig, libusb1, libiconv }:

stdenv.mkDerivation rec {
  name = "libmtp-1.1.18";

  src = fetchurl {
    url = "mirror://sourceforge/libmtp/${name}.tar.gz";
    sha256 = "1w41l93yi0dmw218daiw36rylkc8rammxx37csh1ij24q18gx03j";
  };

  outputs = [ "bin" "dev" "out" ];

  buildInputs = [ libiconv ];
  propagatedBuildInputs = [ libusb1 ];
  nativeBuildInputs = [ pkgconfig ];

  # tried to install files to /lib/udev, hopefully OK
  configureFlags = [ "--with-udev=$$bin/lib/udev" ];

  meta = with stdenv.lib; {
    homepage = "http://libmtp.sourceforge.net";
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
