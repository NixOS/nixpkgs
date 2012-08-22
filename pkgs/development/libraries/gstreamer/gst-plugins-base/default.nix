{ fetchurl, stdenv, pkgconfig, python, gstreamer
, xlibs, alsaLib, cdparanoia, libogg
, libtheora, libvorbis, freetype, pango
, liboil, glib
, # Whether to build no plugins that have external dependencies
  # (except the ALSA plugin).
  minimalDeps ? false
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-base-0.11.93";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-plugins-base/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "d0cce74557a7815c0a9dae7ae9241eea6314478e0bfa3759dbac1b63bcff51d8";
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

