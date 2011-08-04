{ fetchurl, stdenv, pkgconfig, python, gstreamer
, xlibs, alsaLib, cdparanoia, libogg
, libtheora, libvorbis, freetype, pango
, liboil, glib
, # Whether to build no plugins that have external dependencies
  # (except the ALSA plugin).
  minimalDeps ? false
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-base-0.10.35";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-plugins-base/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "00vis5kg6km26zaq1ywz7ki9xvkwpc9c5wn41d01z2i5nldz096d";
  };

  patchPhase = ''
    sed -i 's@/bin/echo@echo@g' configure
    sed -i -e 's/^   /\t/' docs/{libs,plugins}/Makefile.in
  '';

  # TODO : v4l, libvisual
  buildInputs =
    [ pkgconfig glib alsaLib ]
    ++ stdenv.lib.optionals (!minimalDeps)
      [ xlibs.xlibs xlibs.libXv cdparanoia libogg libtheora libvorbis
        freetype pango liboil
      ];

  propagatedBuildInputs = [ gstreamer ];
 
  postInstall = "rm -rf $out/share/gtk-doc";
  
  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "Base plug-ins for GStreamer";

    license = "LGPLv2+";
  };
}
