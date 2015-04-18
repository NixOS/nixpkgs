{ stdenv, fetchurl, pkgconfig, libusb }:

stdenv.mkDerivation rec {
  name = "usbredir-${version}";
  version = "0.7";

  src = fetchurl {
    url = "http://spice-space.org/download/usbredir/${name}.tar.bz2";
    sha256 = "1ah64271r83lvh8hrpkxzv0iwpga1wkrfkx4rkljpijx5dqs0qqa";
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
