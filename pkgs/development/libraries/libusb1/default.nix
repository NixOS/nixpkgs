{ stdenv, fetchurl, pkgconfig, udev }:

let
  version = "1.0.18";
in
stdenv.mkDerivation rec {
  name = "libusb-${version}"; # at 1.0.18 libusb joined with libusbx

  src = fetchurl {
    url = "mirror://sourceforge/libusb/libusb-${version}.tar.bz2";
    sha256 = "081px0j98az0pjwwyjlq4qcmfn194fvm3qd4im0r9pm58pn5qgy7";
  };

  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = stdenv.lib.optional (stdenv.isLinux) udev;

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  meta = {
    homepage = http://www.libusb.info;
    description = "User-space USB library";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
