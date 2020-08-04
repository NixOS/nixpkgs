{ fetchurl, fetchpatch, stdenv, pkgconfig, gstreamer, xorg, alsaLib, cdparanoia
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

  patches = [
    ./gcc-4.9.patch
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/gstreamer/gst-plugins-base/commit/f672277509705c4034bc92a141eefee4524d15aa.patch";
      name = "CVE-2019-9928.patch";
      sha256 = "1dlamsmyr7chrb6vqqmwikqvvqcx5l7k72p98448qm6k59ndnimc";
    })
  ];

  postPatch = ''
    sed -i 's@/bin/echo@echo@g' configure
    sed -i -e 's/^   /\t/' docs/{libs,plugins}/Makefile.in
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
    homepage    = "https://gstreamer.freedesktop.org";
    description = "Base plug-ins for GStreamer";
    license     = licenses.lgpl2Plus;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
    # https://github.com/NixOS/nixpkgs/pull/91090#issuecomment-653753497
    broken = true;
  };
}
