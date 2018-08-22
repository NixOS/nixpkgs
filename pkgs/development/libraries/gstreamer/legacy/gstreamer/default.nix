{ fetchurl, stdenv, perl, bison, flex, pkgconfig, glib, libxml2, libintl }:

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

  nativeBuildInputs = [ pkgconfig libintl ];
  buildInputs = [ perl bison flex ];
  propagatedBuildInputs = [ glib libxml2 ];

  # See https://trac.macports.org/ticket/40783 for explanation of patch
  patches = stdenv.lib.optional stdenv.isDarwin ./darwin.patch;

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

    paxmark m $out/bin/gst-launch* $out/libexec/gstreamer-*/gst-plugin-scanner
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
