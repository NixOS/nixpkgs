{ stdenv, fetchurl, pkgconfig, libusb }:

stdenv.mkDerivation rec {
  name = "usbredir-${version}";
  version = "0.8.0";

  src = fetchurl {
    url = "https://spice-space.org/download/usbredir/${name}.tar.bz2";
    sha256 = "002yik1x7kn0427xahvnhjby2np14a6xqw7c3dx530n9h5d9rg47";
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
