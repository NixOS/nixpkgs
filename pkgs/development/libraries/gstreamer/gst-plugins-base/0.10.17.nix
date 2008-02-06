args: with args;

stdenv.mkDerivation rec {
  name = "gst-plugins-base-" + version;

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-base/${name}.tar.bz2";
    sha256 = "03gpfhdaw7yz83y0wpq966b9dqpvw8v5kpixa1pp4mn7d5bgsb7q";
  };

  patchPhase = "sed -i 's@/bin/echo@echo@g' configure";

  configureFlags = "--enable-shared --disable-static";

# TODO : v4l, libvisual
  propagatedBuildInputs = [gstreamer libX11 libXv libXext alsaLib cdparanoia
    gnomevfs libogg libtheora libvorbis freetype pango liboil gtk];

  buildInputs = [pkgconfig python];

  meta = {
    homepage = http://gstreamer.freedesktop.org;
  };
}
