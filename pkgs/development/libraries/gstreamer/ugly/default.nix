{ stdenv, fetchurl, meson, ninja, pkgconfig, python
, gst-plugins-base, orc, gettext
, a52dec, libcdio, libdvdread
, libmad, libmpeg2, x264, libintl, lib
, darwin
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-ugly-${version}";
  version = "1.14.4";

  meta = with lib; {
    description = "Gstreamer Ugly Plugins";
    homepage    = "https://gstreamer.freedesktop.org";
    longDescription = ''
      a set of plug-ins that have good quality and correct functionality,
      but distributing them might pose problems.  The license on either
      the plug-ins or the supporting libraries might not be how we'd
      like. The code might be widely known to present patent problems.
    '';
    license     = licenses.lgpl2Plus;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ matthewbauer ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-ugly/${name}.tar.xz";
    sha256 = "08vd1xgwmapnviah47zv5h2r02qdd20y4f07rvv5zhv6y4vxh0mc";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja gettext pkgconfig python ];

  buildInputs = [
    gst-plugins-base orc
    a52dec libcdio libdvdread
    libmad libmpeg2 x264
    libintl
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks;
    [ IOKit CoreFoundation DiskArbitration ]);

  NIX_LDFLAGS = [ "-lm" ];
}
