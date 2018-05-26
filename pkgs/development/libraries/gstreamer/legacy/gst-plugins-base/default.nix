{ fetchurl, stdenv, pkgconfig, python, gstreamer, xorg, alsaLib, cdparanoia
, libogg, libtheora, libvorbis, freetype, pango, liboil, glib, cairo, orc
, libintl
, ApplicationServices
, # Whether to build no plugins that have external dependencies
  # (except the ALSA plugin).
  minimalDeps ? false
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-base-0.10.36";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-plugins-base/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "0jp6hjlra98cnkal4n6bdmr577q8mcyp3c08s3a02c4hjhw5rr0z";
  };

  patchPhase = ''
    sed -i 's@/bin/echo@echo@g' configure
    sed -i -e 's/^   /\t/' docs/{libs,plugins}/Makefile.in

    patch -p1 < ${./gcc-4.9.patch}
  '';

  outputs = [ "out" "dev" ];

  # TODO : v4l, libvisual
  buildInputs =
    [ pkgconfig glib cairo orc libintl ]
    # can't build alsaLib on darwin
    ++ stdenv.lib.optional (!stdenv.isDarwin) alsaLib
    ++ stdenv.lib.optionals (!minimalDeps)
      [ xorg.xlibsWrapper xorg.libXv libogg libtheora libvorbis freetype pango
        liboil ]
    # can't build cdparanoia on darwin
    ++ stdenv.lib.optional (!minimalDeps && !stdenv.isDarwin) cdparanoia
    ++ stdenv.lib.optional stdenv.isDarwin ApplicationServices;

  propagatedBuildInputs = [ gstreamer ];

  postInstall = "rm -rf $out/share/gtk-doc";

  meta = with stdenv.lib; {
    homepage    = https://gstreamer.freedesktop.org;
    description = "Base plug-ins for GStreamer";
    license     = licenses.lgpl2Plus;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
