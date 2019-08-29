{ stdenv, fetchurl, bison, libuuid, curl, libxml2, flex }:

stdenv.mkDerivation rec {
  version = "3.20.4";
  name = "libdap-${version}";

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ libuuid curl libxml2 ];

  src = fetchurl {
    url = "https://www.opendap.org/pub/source/${name}.tar.gz";
    sha256 = "0x44igs389b49nb2psd656wpvmbx9bwmla2l5ahfa09vxb314s5i";
  };

  meta = with stdenv.lib; {
    description = "A C++ SDK which contains an implementation of DAP";
    homepage = https://www.opendap.org/software/libdap;
    license = licenses.lgpl2;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.linux;
  };
}
