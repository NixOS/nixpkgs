{ stdenv, fetchurl, pkgconfig, python
, gst-plugins-base, orc, bzip2
, libv4l, libdv, libavc1394, libiec61883
, libvpx, speex, flac, taglib, libshout
, cairo, gdk_pixbuf, aalib, libcaca
, libsoup, libpulseaudio, libintlOrEmpty
, darwin
}:

let
  inherit (stdenv.lib) optionals optionalString;
in
stdenv.mkDerivation rec {
  name = "gst-plugins-good-1.10.4";

  meta = with stdenv.lib; {
    description = "Gstreamer Good Plugins";
    homepage    = "http://gstreamer.freedesktop.org";
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
    sha256 = "0zjdwxn83sp9wjp9rxjbyk8kf284g9av7l2v6rjldi586hacd1la";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig python ];

  buildInputs = [
    gst-plugins-base orc bzip2
    libdv libvpx speex flac taglib
    cairo gdk_pixbuf aalib libcaca
    libsoup libshout
  ]
  ++ libintlOrEmpty
  ++ optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Cocoa ]
  ++ optionals stdenv.isLinux [ libv4l libpulseaudio libavc1394 libiec61883 ];

  preFixup = ''
    mkdir -p "$dev/lib/gstreamer-1.0"
    mv "$out/lib/gstreamer-1.0/"*.la "$dev/lib/gstreamer-1.0"
  '';

  LDFLAGS = optionalString stdenv.isDarwin "-lintl";
}
