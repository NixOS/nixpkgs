{ fetchurl, stdenv, pkgconfig, python, gstreamer
, libX11, libXv, libXext, alsaLib, cdparanoia , libogg
, libtheora, libvorbis, freetype, pango
, liboil, gtk, which, gtkdoc }:

stdenv.mkDerivation rec {
  name = "gst-plugins-base-0.10.30";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-plugins-base/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "1mw5n1w7l0hgyzf75srdxlh3knfgrmddbs2ah1f97s8b710qd4v3";
  };

  patchPhase = ''
    sed -i 's@/bin/echo@echo@g' configure
    sed -i -e 's/^   /\t/' docs/{libs,plugins}/Makefile.in
  '';

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
