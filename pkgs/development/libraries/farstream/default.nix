{ stdenv
, fetchurl
, fetchpatch
, libnice
, pkgconfig
, autoreconfHook
, gstreamer
, gst-plugins-base
, gupnp-igd
, gobject-introspection
, gst-plugins-good
, gst-plugins-bad
, gst-libav
}:

stdenv.mkDerivation rec {
  name = "farstream-0.2.8";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://www.freedesktop.org/software/farstream/releases/farstream/${name}.tar.gz";
    sha256 = "0249ncd20x5mf884fd8bw75c3118b9fdml837v4fib349xmrqfrb";
  };

  patches = [
    # Python has not been used for ages
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/farstream/farstream/commit/73891c28fa27d5e65a71762e826f13747d743588.patch";
      sha256 = "19pw1m8xhxyf5yhl6k898w240ra2k0m28gfv858x70c4wl786lrn";
    })
  ];

  buildInputs = [
    libnice
    gupnp-igd
    libnice
  ];

  nativeBuildInputs = [
    pkgconfig
    autoreconfHook
    gobject-introspection
  ];

  propagatedBuildInputs = [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-libav
  ];

  meta = with stdenv.lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/Farstream";
    description = "Audio/Video Communications Framework formely known as farsight";
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
