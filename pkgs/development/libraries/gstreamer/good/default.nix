{ stdenv, fetchurl, meson, ninja, pkgconfig, python
, gst-plugins-base, orc, bzip2, gettext
, libv4l, libdv, libavc1394, libiec61883
, libvpx, speex, flac, taglib, libshout
, cairo, gdk_pixbuf, aalib, libcaca
, libsoup, libpulseaudio, libintl
, darwin, lame, mpg123, twolame
, gtkSupport ? false, gtk3 ? null
}:

assert gtkSupport -> gtk3 != null;

let
  inherit (stdenv.lib) optionals optionalString;
in
stdenv.mkDerivation rec {
  name = "gst-plugins-good-1.14.0";

  meta = with stdenv.lib; {
    description = "Gstreamer Good Plugins";
    homepage    = "https://gstreamer.freedesktop.org";
    longDescription = ''
      a set of plug-ins that we consider to have good quality code,
      correct functionality, our preferred license (LGPL for the plug-in
      code, LGPL or LGPL-compatible for the supporting library).
    '';
    license     = licenses.lgpl2Plus;
    platforms   = platforms.linux ++ platforms.darwin;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-good/${name}.tar.xz";
    sha256 = "1226s30cf7pqg3fj8shd20l7sp93yw9sqplgxns3m3ajgms3byka";
  };

  outputs = [ "out" "dev" ];

  patches = [ ./fix_pkgconfig_includedir.patch ];

  nativeBuildInputs = [ pkgconfig python meson ninja gettext ];

  buildInputs = [
    gst-plugins-base orc bzip2
    libdv libvpx speex flac taglib
    cairo gdk_pixbuf aalib libcaca
    libsoup libshout lame mpg123 twolame libintl
  ]
  ++ optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Cocoa ]
  ++ optionals stdenv.isLinux [ libv4l libpulseaudio libavc1394 libiec61883 ];

}
