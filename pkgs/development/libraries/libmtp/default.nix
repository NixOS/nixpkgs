{ stdenv, fetchurl, libusb }:

stdenv.mkDerivation rec {
  name = "libmtp-1.0.1";

  propagatedBuildInputs = [ libusb ];

  src = fetchurl {
    url = "mirror://sourceforge/libmtp/${name}.tar.gz";
    sha256 = "19iha1yi07cdqzlba4ng1mn7h701binalwwkb71q0ld9b88mad6s";
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
