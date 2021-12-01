{ lib, stdenv
, fetchurl
, fetchpatch
, libnice
, pkg-config
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
  pname = "farstream";
  version = "0.2.8";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://www.freedesktop.org/software/farstream/releases/farstream/${pname}-${version}.tar.gz";
    sha256 = "0249ncd20x5mf884fd8bw75c3118b9fdml837v4fib349xmrqfrb";
  };

  patches = [
    # Python has not been used for ages
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/farstream/farstream/commit/73891c28fa27d5e65a71762e826f13747d743588.patch";
      sha256 = "19pw1m8xhxyf5yhl6k898w240ra2k0m28gfv858x70c4wl786lrn";
    })
    # Fix build with newer gnumake.
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/farstream/farstream/-/commit/54987d44.diff";
      sha256 = "02pka68p2j1wg7768rq7afa5wl9xv82wp86q7izrmwwnxdmz4zyg";
    })
  ];

  buildInputs = [
    libnice
    gupnp-igd
    libnice
  ];

  nativeBuildInputs = [
    pkg-config
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

  meta = with lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/Farstream";
    description = "Audio/Video Communications Framework formely known as farsight";
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
