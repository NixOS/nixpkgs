{ stdenv, fetchurl, meson, ninja, pkgconfig, python
, gst-plugins-base, orc, bzip2, gettext
, libv4l, libdv, libavc1394, libiec61883
, libvpx, speex, flac, taglib, libshout
, cairo, gdk_pixbuf, aalib, libcaca
, libsoup, libpulseaudio, libintl
, darwin, lame, mpg123, twolame
, gtkSupport ? false, gtk3 ? null
, libXdamage
, libXext
, libXfixes
, ncurses
, xorg
, libgudev
, wavpack
, jack2
}:

assert gtkSupport -> gtk3 != null;

let
  inherit (stdenv.lib) optional optionals;
in
stdenv.mkDerivation rec {
  name = "gst-plugins-good-${version}";
  version = "1.15.1";

  meta = with stdenv.lib; {
    description = "Gstreamer Good Plugins";
    homepage    = "https://gstreamer.freedesktop.org";
    longDescription = ''
      a set of plug-ins that we consider to have good quality code,
      correct functionality, our preferred license (LGPL for the plug-in
      code, LGPL or LGPL-compatible for the supporting library).
    '';
    license     = licenses.lgpl2Plus;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ matthewbauer ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-good/${name}.tar.xz";
    sha256 = "15f6klr7wg6jlcyx0qspi13s8wmc9fij1bx1bbvy90a9a72v97rb";
  };

  outputs = [ "out" "dev" ];

  patches = [ ./fix_pkgconfig_includedir.patch ];

  nativeBuildInputs = [ pkgconfig python meson ninja gettext ];

  NIX_LDFLAGS = "-lncurses";

  buildInputs = [
    gst-plugins-base orc bzip2
    libdv libvpx speex flac taglib
    cairo gdk_pixbuf aalib libcaca
    libsoup libshout lame mpg123 twolame libintl
    # TODO: Remove the comments once https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/commit/e234932dc703e51a0e1aa3b9c408f12758b12335
    # is merged and available in nixpkgs.
    libXdamage # present feature but undeclared in meson_options.txt, see https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/issues/553
    libXext # present feature but undeclared in meson_options.txt, see https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/issues/553
    libXfixes # present feature but undeclared in meson_options.txt, see https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/issues/553
    ncurses
    xorg.libXfixes # present feature but undeclared in meson_options.txt, see https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/issues/553
    xorg.libXdamage # present feature but undeclared in meson_options.txt, see https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/issues/553
    wavpack
  ]
  ++ optional gtkSupport gtk3 # for gtksink
  ++ optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Cocoa ]
  ++ optionals stdenv.isLinux [ libv4l libpulseaudio libavc1394 libiec61883 libgudev jack2 ];

  mesonFlags = [
    # Enables all features, so that we know when new dependencies are necessary.
    "-Dauto_features=enabled"
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
    "-Dqt5=disabled" # not clear as of writing how to correctly pass in the required qt5 deps
  ]
  ++ optional (!gtkSupport) "-Dgtk3=disabled"
  ++ optionals (!stdenv.isLinux) [
    "-Djack=disabled" # unclear whether Jack works on Darwin
  ]
  ++ optionals (!stdenv.isLinux) [
    "-Dv4l2-gudev=disabled"
  ];

  # fails 1 tests with "Unexpected critical/warning: g_object_set_is_valid_property: object class 'GstRtpStorage' has no property named ''"
  doCheck = false;

}
