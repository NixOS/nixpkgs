{ stdenv, fetchurl, pkgconfig, libusb1, libiconv }:

stdenv.mkDerivation rec {
  name = "libmtp-1.1.16";

  src = fetchurl {
    url = "mirror://sourceforge/libmtp/${name}.tar.gz";
    sha256 = "185vh9bds6dcy00ycggg69g4v7m3api40zv8vrcfb3fk3vfzjs2v";
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
