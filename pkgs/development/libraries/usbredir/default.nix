{ stdenv, fetchurl, pkgconfig, libusb }:

stdenv.mkDerivation rec {
  name = "usbredir-${version}";
  version = "0.6";

  src = fetchurl {
    url = "http://spice-space.org/download/usbredir/${name}.tar.bz2";
    sha256 = "028184960044ea4124030000b3c55a35c3238835116e3a0fbcaff449df2c8edf";
  };

  buildInputs = [ pkgconfig libusb ];
  propagatedBuildInputs = [ libusb ];

  meta = with stdenv.lib; {
    description = "USB traffic redirection protocol";
    homepage = http://spice-space.org/page/UsbRedir;
    license = licenses.lgpl21;

    maintainers = [ maintainers.offline ];
    platforms = platforms.linux;
  };
}
