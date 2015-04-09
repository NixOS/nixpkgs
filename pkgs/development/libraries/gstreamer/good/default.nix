{ stdenv, fetchurl, pkgconfig, python
, gst-plugins-base, orc, bzip2
, libv4l, libdv, libavc1394, libiec61883
, libvpx, speex, flac, taglib
, cairo, gdk_pixbuf, aalib, libcaca
, libsoup, pulseaudio, libintlOrEmpty
}:

let
  inherit (stdenv.lib) optionals optionalString;
in
stdenv.mkDerivation rec {
  name = "gst-plugins-good-1.4.5";

  meta = with stdenv.lib; {
    description = "Gstreamer Good Plugins";
    homepage    = "http://gstreamer.freedesktop.org";
    longDescription = ''
      a set of plug-ins that we consider to have good quality code,
      correct functionality, our preferred license (LGPL for the plug-in
      code, LGPL or LGPL-compatible for the supporting library).
    '';
    license     = licenses.lgpl2Plus;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-good/${name}.tar.xz";
    sha256 = "0hg6qzdpib9nwn3hdxv0d4rvivi1c4bmxsq2a9hqmamwyzrvbcbr";
  };

  nativeBuildInputs = [ pkgconfig python ];

  buildInputs = [
    gst-plugins-base orc bzip2
    libdv libvpx speex flac taglib
    cairo gdk_pixbuf aalib libcaca
    libsoup
  ]
  ++ libintlOrEmpty
  ++ optionals stdenv.isLinux [ libv4l pulseaudio libavc1394 libiec61883 ];

  LDFLAGS = optionalString stdenv.isDarwin "-lintl";
}
