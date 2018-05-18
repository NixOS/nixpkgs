{ stdenv, fetchurl, pkgconfig, libusb }:

stdenv.mkDerivation rec {
  name = "usbredir-${version}";
  version = "0.7.1";

  src = fetchurl {
    url = "http://spice-space.org/download/usbredir/${name}.tar.bz2";
    sha256 = "1wsnmk4wjpdhbn1zaxg6bmyxspcki2zgy0am9lk037rnl4krwzj0";
  };

  NIX_CFLAGS_COMPILE = [ "-Wno-error" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libusb ];
  propagatedBuildInputs = [ libusb ];

  outputs = [ "out" "dev" ];

  meta = with stdenv.lib; {
    description = "USB traffic redirection protocol";
    homepage = http://spice-space.org/page/UsbRedir;
    license = licenses.lgpl21;

    maintainers = [ maintainers.offline ];
    platforms = platforms.linux;
  };
}
