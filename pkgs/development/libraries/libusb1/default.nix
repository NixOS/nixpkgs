{ stdenv, fetchurl, pkgconfig, udev ? null, libobjc, IOKit }:

stdenv.mkDerivation rec {
  name = "libusb-1.0.19";

  src = fetchurl {
    url = "mirror://sourceforge/libusb/${name}.tar.bz2";
    sha256 = "0h38p9rxfpg9vkrbyb120i1diq57qcln82h5fr7hvy82c20jql3c";
  };

  buildInputs = [ pkgconfig ];
  propagatedBuildInputs =
    stdenv.lib.optional stdenv.isLinux udev ++
    stdenv.lib.optionals stdenv.isDarwin [ libobjc IOKit ];

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  preFixup = stdenv.lib.optionalString stdenv.isLinux ''
    sed 's,-ludev,-L${udev}/lib -ludev,' -i $out/lib/libusb-1.0.la
  '';

  meta = {
    homepage = http://www.libusb.info;
    description = "User-space USB library";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
