args: with args;

let version = "0.10.10"; in
  stdenv.mkDerivation rec {
    name = "gnonlin-${version}";

    src = fetchurl {
      url = "http://gstreamer.freedesktop.org/src/gnonlin/gnonlin-${version}.tar.gz";
      sha256 = "041in2y0x3755hw29rhnyhsh216v2fl1q1p12m9faxiv2r52x83y";
    };

    buildInputs = [  gstPluginsBase gstreamer pkgconfig ];

    configureFlags = "--enable-shared --disable-static";

    meta = {
      homepage = "http://gstreamer.freedesktop.org/modules/gnonlin.html";
      description = "http://gstreamer.freedesktop.org/modules/gnonlin.html";
      license = "GPLv2+";
    };
  }
