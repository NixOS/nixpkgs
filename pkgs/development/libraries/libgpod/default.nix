{stdenv, fetchurl, gettext, perl, perlXMLParser, intltool, pkgconfig, glib,
  libxml2, sqlite, libplist, libusb1, zlib, sg3_utils, gtk, taglib,
  libimobiledevice, python, pygobject, mutagen, swig }:

stdenv.mkDerivation rec {
  name = "libgpod-0.7.94";
  src = fetchurl {
    url = "mirror://sourceforge/gtkpod/${name}.tar.gz";
    sha256 = "0bs6p5np8kbyhvkj4vza2dmq7qfsf48chx00hirkf3mqccp41xk4";
  };

  patchPhase = ''sed -e "s,udevdir=,&$out," -i configure'';
  configureFlags = "--without-hal --enable-udev";

  buildInputs = [ gettext perl perlXMLParser intltool pkgconfig glib libxml2
    sqlite libplist libusb1 zlib sg3_utils gtk taglib libimobiledevice
    python pygobject mutagen swig ];

  meta = {
    homepage = http://gtkpod.sourceforge.net/;
    description = "Library used by gtkpod to access the contents of an ipod";
    license = "LGPL";
  };
}
