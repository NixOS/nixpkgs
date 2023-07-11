{ lib, stdenv
, fetchurl
, meson
, nasm
, ninja
, pkg-config
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
, Cocoa
, lame
, mpg123
, twolame
, gtkSupport ? false, gtk3
, qt5Support ? false, qt5
, qt6Support ? false, qt6
, raspiCameraSupport ? false, libraspberrypi
, enableJack ? true, libjack2
, enableX11 ? stdenv.isLinux, xorg
, ncurses
, wayland
, wayland-protocols
, libgudev
, wavpack
, glib
# Checks meson.is_cross_build(), so even canExecute isn't enough.
, enableDocumentation ? stdenv.hostPlatform == stdenv.buildPlatform, hotdoc
}:

assert raspiCameraSupport -> (stdenv.isLinux && stdenv.isAarch64);

stdenv.mkDerivation rec {
  pname = "gst-plugins-good";
  version = "1.22.4";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-1xIMEUap1yPVPVv+gHTaJXWoHwWYQ4dSk385u3yDO2o=";
  };

  strictDeps = true;

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    pkg-config
    python3
    meson
    ninja
    gettext
    nasm
    orc
    libshout
    glib
  ] ++ lib.optionals enableDocumentation [
    hotdoc
  ] ++ lib.optionals qt5Support (with qt5; [
    qtbase
  ]) ++ lib.optionals qt6Support (with qt6; [
    qtbase
    qttools
  ]) ++ lib.optionals stdenv.isLinux [
    wayland-protocols
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
    ncurses
    wavpack
  ] ++ lib.optionals raspiCameraSupport [
    libraspberrypi
  ] ++ lib.optionals enableX11 [
    xorg.libXext
    xorg.libXfixes
    xorg.libXdamage
  ] ++ lib.optionals gtkSupport [
    # for gtksink
    gtk3
  ] ++ lib.optionals qt5Support (with qt5; [
    qtbase
    qtdeclarative
    qtwayland
    qtx11extras
  ]) ++ lib.optionals qt6Support (with qt6; [
    qtbase
    qtdeclarative
    qtwayland
  ]) ++ lib.optionals stdenv.isDarwin [
    Cocoa
  ] ++ lib.optionals stdenv.isLinux [
    libv4l
    libpulseaudio
    libavc1394
    libiec61883
    libgudev
    wayland
  ] ++ lib.optionals enableJack [
    libjack2
  ];

  mesonFlags = [
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
    "-Dglib-asserts=disabled" # asserts should be disabled on stable releases
    (lib.mesonEnable "doc" enableDocumentation)
  ] ++ lib.optionals (!qt5Support) [
    "-Dqt5=disabled"
  ] ++ lib.optionals (!qt6Support) [
    "-Dqt6=disabled"
  ] ++ lib.optionals (!gtkSupport) [
    "-Dgtk3=disabled"
  ] ++ lib.optionals (!enableX11) [
    "-Dximagesrc=disabled" # Linux-only
  ] ++ lib.optionals (!enableJack) [
    "-Djack=disabled"
  ] ++ lib.optionals (!stdenv.isLinux) [
    "-Ddv1394=disabled" # Linux only
    "-Doss4=disabled" # Linux only
    "-Doss=disabled" # Linux only
    "-Dpulse=disabled" # TODO check if we can keep this enabled
    "-Dv4l2-gudev=disabled" # Linux-only
    "-Dv4l2=disabled" # Linux-only
  ] ++ lib.optionals (!raspiCameraSupport) [
    "-Drpicamsrc=disabled"
  ];

  postPatch = ''
    patchShebangs \
      scripts/extract-release-date-from-doap-file.py
  '';

  NIX_LDFLAGS = [
    # linking error on Darwin
    # https://github.com/NixOS/nixpkgs/pull/70690#issuecomment-553694896
    "-lncurses"
  ];

  # fails 1 tests with "Unexpected critical/warning: g_object_set_is_valid_property: object class 'GstRtpStorage' has no property named ''"
  doCheck = false;

  # must be explicitly set since 5590e365
  dontWrapQtApps = true;

  meta = with lib; {
    description = "GStreamer Good Plugins";
    homepage = "https://gstreamer.freedesktop.org";
    longDescription = ''
      a set of plug-ins that we consider to have good quality code,
      correct functionality, our preferred license (LGPL for the plug-in
      code, LGPL or LGPL-compatible for the supporting library).
    '';
    license = licenses.lgpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ matthewbauer lilyinstarlight ];
  };
}
