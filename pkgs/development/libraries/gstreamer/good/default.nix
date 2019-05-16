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
}:

assert gtkSupport -> gtk3 != null;

let
  inherit (stdenv.lib) optional optionals;
in
stdenv.mkDerivation rec {
  name = "gst-plugins-good-${version}";
  version = "1.14.4";

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
    sha256 = "0y89qynb4b6fry3h43z1r99qslmi3m8xhlq0i5baq2nbc0r5b2sz";
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
  ]
  ++ optional gtkSupport gtk3 # for gtksink
  ++ optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Cocoa ]
  ++ optionals stdenv.isLinux [ libv4l libpulseaudio libavc1394 libiec61883 ];

  # fails 1 tests with "Unexpected critical/warning: g_object_set_is_valid_property: object class 'GstRtpStorage' has no property named ''"
  doCheck = false;

}
