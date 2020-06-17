{ stdenv, fetchurl, pkgconfig, libusb1 }:

stdenv.mkDerivation rec {
  pname = "usbredir";
  version = "0.8.0";

  src = fetchurl {
    url = "https://spice-space.org/download/usbredir/${pname}-${version}.tar.bz2";
    sha256 = "002yik1x7kn0427xahvnhjby2np14a6xqw7c3dx530n9h5d9rg47";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error";

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ libusb1 ];

  outputs = [ "out" "dev" ];

  meta = with stdenv.lib; {
    description = "USB traffic redirection protocol";
    homepage = "https://www.spice-space.org/usbredir.html";
    license = licenses.lgpl21;

    maintainers = [ maintainers.offline ];
    platforms = platforms.linux;
  };
}
