{stdenv, lib, fetchurl, gettext, perl, perlXMLParser, intltool, pkgconfig, glib,
  libxml2, sqlite, libusb1, zlib, sg3_utils, gdk_pixbuf, taglib,
  libimobiledevice, pythonPackages, mutagen,
  monoSupport ? true, mono, gtk-sharp-2_0
}:

let
  inherit (pythonPackages) python pygobject2;
in stdenv.mkDerivation rec {
  name = "libgpod-0.8.3";
  src = fetchurl {
    url = "mirror://sourceforge/gtkpod/${name}.tar.bz2";
    sha256 = "0pcmgv1ra0ymv73mlj4qxzgyir026z9jpl5s5bkg35afs1cpk2k3";
  };

  preConfigure = "configureFlagsArray=( --with-udev-dir=$out/lib/udev )";

  configureFlags = [
    "--without-hal"
    "--enable-udev"
  ] ++ lib.optionals monoSupport [ "--with-mono" ];

  dontStrip = true;

  propagatedBuildInputs = [ glib libxml2 sqlite zlib sg3_utils
    gdk_pixbuf taglib libimobiledevice python pygobject2 mutagen ];

  nativeBuildInputs = [ gettext perlXMLParser intltool pkgconfig perl
    libimobiledevice.swig ] ++ lib.optionals monoSupport [ mono gtk-sharp-2_0 ];

  meta = {
    homepage = http://gtkpod.sourceforge.net/;
    description = "Library used by gtkpod to access the contents of an ipod";
    license = "LGPL";
    platforms = stdenv.lib.platforms.gnu;
    maintainers = [ ];
  };
}
