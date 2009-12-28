{ fetchurl, stdenv, pkgconfig, python, gstreamer
, libX11, libXv, libXext, alsaLib, cdparanoia , libogg
, libtheora, libvorbis, freetype, pango
, liboil, gtk, which, gtkdoc, ... }:

stdenv.mkDerivation rec {
  name = "gst-plugins-base-0.10.25";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-plugins-base/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "01s61nm1svs2lqlpjlp3yywa3m39p81awklwx4dszrqqv3hzgcha";
  };

  patchPhase = "sed -i 's@/bin/echo@echo@g' configure";

# TODO : v4l, libvisual
  propagatedBuildInputs = [gstreamer libX11 libXv libXext alsaLib cdparanoia
    libogg libtheora libvorbis freetype pango liboil gtk which gtkdoc];

  buildInputs = [pkgconfig python];

  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "Base plug-ins for GStreamer";

    license = "LGPLv2+";
  };
}
