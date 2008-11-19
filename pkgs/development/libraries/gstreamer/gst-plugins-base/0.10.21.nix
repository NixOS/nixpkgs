args: with args;

stdenv.mkDerivation rec {
  name = "gst-plugins-base-" + version;

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-base/${name}.tar.bz2";
    sha256 = "14vyshhxpdpfd06jyw1fgcfxb6nh0bg7n2aqd9h9kapkl12llgv7";
  };

  patchPhase = "sed -i 's@/bin/echo@echo@g' configure";

  configureFlags = "--enable-shared --disable-static";

# TODO : v4l, libvisual
  propagatedBuildInputs = [gstreamer libX11 libXv libXext alsaLib cdparanoia
    libogg libtheora libvorbis freetype pango liboil gtk which gtkdoc];

  buildInputs = [pkgconfig python];

  meta = {
    homepage = http://gstreamer.freedesktop.org;
  };
}
