{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
, python3
, gst-plugins-base
, orc
, bzip2
, gettext
, libv4l
, libdv
, libavc1394
, libiec61883
, libvpx
, speex
, flac
, taglib
, libshout
, cairo
, gdk-pixbuf
, aalib
, libcaca
, libsoup
, libpulseaudio
, libintl
, darwin
, lame
, mpg123
, twolame
, gtkSupport ? false, gtk3 ? null
  # As of writing, jack2 incurs a Qt dependency (big!) via `ffado`.
  # In the future we should probably split `ffado`.
, enableJack ? false, jack2
, libXdamage
, libXext
, libXfixes
, ncurses
, xorg
, libgudev
, wavpack
}:

assert gtkSupport -> gtk3 != null;

let
  inherit (stdenv.lib) optionals;
in
stdenv.mkDerivation rec {
  pname = "gst-plugins-good";
  version = "1.16.2";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "068k3cbv1yf3gbllfdzqsg263kzwh21y8dpwr0wvgh15vapkpfs0";
  };

  patches = [ ./fix_pkgconfig_includedir.patch ];

  nativeBuildInputs = [
    pkgconfig
    python3
    meson
    ninja
    gettext
  ];

  buildInputs = [
    gst-plugins-base
    orc
    bzip2
    libdv
    libvpx
    speex
    flac
    taglib
    cairo
    gdk-pixbuf
    aalib
    libcaca
    libsoup
    libshout
    lame
    mpg123
    twolame
    libintl
    libXdamage
    libXext
    libXfixes
    ncurses
    xorg.libXfixes
    xorg.libXdamage
    wavpack
  ] ++ optionals gtkSupport [
    # for gtksink
    gtk3
  ] ++ optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Cocoa
  ] ++ optionals stdenv.isLinux [
    libv4l
    libpulseaudio
    libavc1394
    libiec61883
    libgudev
  ] ++ optionals (stdenv.isLinux && enableJack) [
    jack2
  ];

  mesonFlags = [
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
    "-Dqt5=disabled" # not clear as of writing how to correctly pass in the required qt5 deps
  ] ++ optionals (!gtkSupport) [
    "-Dgtk3=disabled"
  ] ++ optionals (!stdenv.isLinux || !enableJack) [
    "-Djack=disabled" # unclear whether Jack works on Darwin
  ] ++ optionals (!stdenv.isLinux) [
    "-Ddv1394=disabled" # Linux only
    "-Doss4=disabled" # Linux only
    "-Doss=disabled" # Linux only
    "-Dpulse=disabled" # TODO check if we can keep this enabled
    "-Dv4l2-gudev=disabled" # Linux-only
    "-Dv4l2=disabled" # Linux-only
    "-Dximagesrc=disabled" # Linux-only
    "-Dpulse=disabled" # TODO check if we can keep this enabled
  ];


  NIX_LDFLAGS = [
    # linking error on Darwin
    # https://github.com/NixOS/nixpkgs/pull/70690#issuecomment-553694896
    "-lncurses"
  ];

  # fails 1 tests with "Unexpected critical/warning: g_object_set_is_valid_property: object class 'GstRtpStorage' has no property named ''"
  doCheck = false;

  meta = with stdenv.lib; {
    description = "GStreamer Good Plugins";
    homepage = "https://gstreamer.freedesktop.org";
    longDescription = ''
      a set of plug-ins that we consider to have good quality code,
      correct functionality, our preferred license (LGPL for the plug-in
      code, LGPL or LGPL-compatible for the supporting library).
    '';
    license = licenses.lgpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
