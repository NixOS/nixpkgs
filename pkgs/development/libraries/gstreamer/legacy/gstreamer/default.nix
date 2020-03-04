{ fetchurl, fetchpatch, stdenv, autoreconfHook
, perl, bison, flex, pkgconfig, glib, libxml2, libintl, libunwind
}:

stdenv.mkDerivation rec {
  name = "gstreamer-0.10.36";

  src = fetchurl {
    urls =
      [ "${meta.homepage}/src/gstreamer/${name}.tar.xz"
        "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "1nkid1n2l3rrlmq5qrf5yy06grrkwjh3yxl5g0w58w0pih8allci";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ autoreconfHook flex perl pkgconfig libintl bison glib ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin libunwind;
  propagatedBuildInputs = [ glib libxml2 ];

  patches = [
    (fetchpatch {
      url = "https://github.com/flathub/com.xnview.XnRetro/raw/fec03bbe240f45aa10d7d4eea9d6f066d9b6ac9c/gstreamer-0.10.36-bison3.patch";
      sha256 = "05aarg3yzl5jx3z5838ixv392g0r3kbsi2vfqniaxmidhnfzij2y";
    })
    (fetchpatch {
      url = "https://github.com/GStreamer/common/commit/03a0e5736761a72d4ed880e8c485bbf9e4a8ea47.patch";
      sha256 = "0rin3x01yy78ky3smmhbwlph18hhym18q4x9w6ddiqajg5lk4xhm";
      extraPrefix = "common/";
      stripLen = 1;
    })
    (fetchpatch {
      url = "https://github.com/GStreamer/common/commit/8aadeaaa8a948d7ce62008789ab03e9aa514c2b9.patch";
      sha256 = "0n2mqvq2al7jr2hflhz4l781i3jya5a9i725jvy508ambpgycz3x";
      extraPrefix = "common/";
      stripLen = 1;
    })
    (fetchpatch {
      url = "https://github.com/GStreamer/common/commit/7bb2bcecda471a0d514a964365a78150f3ee5747.patch";
      sha256 = "0famdj70m7wjvr1dpy7iywhrkqxmrshxz0rizz1bixgp42dvkhbq";
      extraPrefix = "common/";
      stripLen = 1;
    })
  ] ++
    # See https://trac.macports.org/ticket/40783 for explanation of patch
    stdenv.lib.optional stdenv.isDarwin ./darwin.patch;

  postPatch = ''
    sed -i -e 's/^   /\t/' docs/gst/Makefile.in docs/libs/Makefile.in docs/plugins/Makefile.in
  '';

  configureFlags = [
    "--disable-examples"
    "--localstatedir=/var"
    "--disable-gtk-doc"
    "--disable-docbook"
  ];

  doCheck = false; # fails. 2 tests crash

  postInstall = ''
    # Hm, apparently --disable-gtk-doc is ignored...
    rm -rf $out/share/gtk-doc
  '';

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = https://gstreamer.freedesktop.org;

    description = "Library for constructing graphs of media-handling components";

    longDescription = ''
      GStreamer is a library for constructing graphs of media-handling
      components.  The applications it supports range from simple
      Ogg/Vorbis playback, audio/video streaming to complex audio
      (mixing) and video (non-linear editing) processing.

      Applications can take advantage of advances in codec and filter
      technology transparently.  Developers can add new codecs and
      filters by writing a simple plugin with a clean, generic
      interface.
    '';

    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
