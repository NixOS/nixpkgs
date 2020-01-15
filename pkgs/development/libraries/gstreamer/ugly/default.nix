{ stdenv, fetchurl, meson, ninja, pkgconfig, python
, gst-plugins-base, orc, gettext
, a52dec, libcdio, libdvdread
, libmad, libmpeg2, x264, libintl, lib
, opencore-amr
, darwin
}:

stdenv.mkDerivation rec {
  pname = "gst-plugins-ugly";
  version = "1.16.0";

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
    url = "${meta.homepage}/src/gst-plugins-ugly/${pname}-${version}.tar.xz";
    sha256 = "1hm46c1fy9vl1wfwipsj41zp79cm7in1fpmjw24j5hriy32n82g3";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja gettext pkgconfig python ];

  buildInputs = [
    gst-plugins-base orc
    a52dec libcdio libdvdread
    libmad libmpeg2 x264
    libintl
    opencore-amr
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks;
    [ IOKit CoreFoundation DiskArbitration ]);

  mesonFlags = [
    # Enables all features, so that we know when new dependencies are necessary.
    "-Dauto_features=enabled"
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
    "-Dsidplay=disabled" # sidplay / sidplay/player.h isn't packaged in nixpkgs as of writing
  ];

  NIX_LDFLAGS = [ "-lm" ];
}
