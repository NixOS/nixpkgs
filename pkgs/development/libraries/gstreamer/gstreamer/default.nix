{ fetchurl, stdenv, perl, python, bison, flex, pkgconfig, glib, libxml2, libintlOrEmpty }:

stdenv.mkDerivation rec {
  name = "gstreamer-1.0.5";

  src = fetchurl {
    urls =
      [ "${meta.homepage}/src/gstreamer/${name}.tar.xz"
        "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "0xsvgi4axavrh0bkjr9h8yq75bmjjs37y7mwlg84d6phcxsq5hi6";
  };

  buildInputs = [ perl python bison flex pkgconfig ];
  propagatedBuildInputs = [ glib libxml2 ] ++ libintlOrEmpty;

  patchPhase = ''
    sed -i -e 's/^   /\t/' docs/gst/Makefile.in docs/libs/Makefile.in docs/plugins/Makefile.in
  '';

  configureFlags = ''
    --disable-examples --enable-failing-tests --localstatedir=/var --disable-gtk-doc --disable-docbook
  '';

  # Hm, apparently --disable-gtk-doc is ignored...
  postInstall = "rm -rf $out/share/gtk-doc";

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "GStreamer, a library for constructing graphs of media-handling components";

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

    license = "LGPLv2+";
  };
}
