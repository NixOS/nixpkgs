{ fetchurl, stdenv, autoconf, automake, libtool, pkgconfig
, gst_plugins_base, bzip2, yasm
, useInternalLibAV ? false, libav ? null }:

stdenv.mkDerivation rec {
  name = "gst-libav-${version}";
  version = "1.0.5";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-libav/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
    ];
    sha256 = "1m9jzga9ahml3dnfm7syz6mglmysqpbkkyr48kka9cwna1kbxy5f";
  };

  preConfigure = "autoreconf -vfi";

  # Upstream strongly recommends against using --with-system-libav,
  # but we do it anyway because we're so hardcore (and we don't want
  # multiple copies of libav).
  configureFlags = stdenv.lib.optionalString (!useInternalLibAV) "--with-system-libav";
  enableParallelBuilding = true; 

  buildInputs =
    [ autoconf automake libtool pkgconfig bzip2 gst_plugins_base ]
    ++ (if useInternalLibAV then [ yasm ] else [ libav ]);

  meta = {
    homepage = http://gstreamer.freedesktop.org;
    description = "GStreamer's plug-in using LibAV";
    license = "GPLv2+";
  };
}
