{ lib, stdenv, fetchurl, pkg-config, libusb1 }:

stdenv.mkDerivation rec {
  pname = "libinklevel";
  version = "0.9.4";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-J0cEaC5v4naO4GGUzdfV55kB7KzA+q+v64i5y5Xbp9Q=";
  };

  buildInputs = [
    pkg-config
    libusb1
  ];

  outputs = [ "out" "dev" "doc" ];

  meta = with lib; {
    description = "A library for checking the ink level of your printer";
    longDescription = ''
      Libinklevel is a library for checking the ink level of your printer on a
      system which runs Linux or FreeBSD. It supports printers attached via
      USB. Currently printers of the following brands are supported: HP, Epson
      and Canon. Canon BJNP network printers are supported too. This is not
      official software from the printer manufacturers. The goal of this
      project is to create a vendor independent API for retrieving the ink
      level of a printer connected to a Linux or FreeBSD box.
    '';
    homepage = "http://libinklevel.sourceforge.net/";
    license = licenses.gpl2;
    platforms = platforms.linux ++ platforms.freebsd;
    maintainers = with maintainers; [ samb96 ];
  };
}
