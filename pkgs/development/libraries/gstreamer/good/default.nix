{ stdenv
, fetchurl
, fetchpatch
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
, enableJack ? true, libjack2
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
  version = "1.16.3";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0pzq565ijl5z3mphvix34878m7hck6a58rdpj7sp7rixwwzkm8nk";
  };

  patches = [
    ./fix_pkgconfig_includedir.patch
    (fetchpatch {
      # https://gstreamer.freedesktop.org/security/sa-2021-0002.html
      name = "CVE-2021-3497.patch";
      url = "https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/-/commit/9181191511f9c0be6a89c98b311f49d66bd46dc3.patch";
      sha256 = "10dvfxrw7l3gflk9fzn5x18vkj4080dfkjnzldc12r5mnl37qdz8";
    })
    (fetchpatch {
      # https://gstreamer.freedesktop.org/security/sa-2021-0003.html
      name = "CVE-2021-3498.patch";
      url = "https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/-/commit/02174790726dd20a5c73ce2002189bf240ad4fe0.patch";
      sha256 = "1sygia6z0yv5grzii6z9bviwi6rm6br3xjr0cnffsji6z943d7vc";
    })
  ];

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
  ] ++ optionals enableJack [
    libjack2
  ];

  mesonFlags = [
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
    "-Dqt5=disabled" # not clear as of writing how to correctly pass in the required qt5 deps
  ] ++ optionals (!gtkSupport) [
    "-Dgtk3=disabled"
  ] ++ optionals (!enableJack) [
    "-Djack=disabled"
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
