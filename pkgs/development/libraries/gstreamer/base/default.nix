{ stdenv, fetchurl, fetchpatch, lib
, pkgconfig, meson, ninja, gettext, gobject-introspection
, python3, gstreamer, orc, pango, libtheora
, libintl, libopus
, isocodes
, libjpeg
, libvisual
, tremor # provides 'virbisidec'
, gtk-doc, docbook_xsl, docbook_xml_dtd_412
, enableX11 ? stdenv.isLinux, libXv
, enableWayland ? stdenv.isLinux, wayland
, enableAlsa ? stdenv.isLinux, alsaLib
, enableCocoa ? false, darwin
, enableCdparanoia ? (!stdenv.isDarwin), cdparanoia }:

stdenv.mkDerivation rec {
  name = "gst-plugins-base-${version}";
  version = "1.15.1";

  meta = with lib; {
    description = "Base plugins and helper libraries";
    homepage = https://gstreamer.freedesktop.org;
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewbauer ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-base/${name}.tar.xz";
    sha256 = "0qvyx9gs7z2ryhdxxzynn9r1gphfk4xfkhd6dma02sbda9c5jckf";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkgconfig python3 gettext gobject-introspection
    gtk-doc
    # Without these, enabling the 'gtk_doc' gives us `FAILED: meson-install`
    docbook_xsl docbook_xml_dtd_412
  ]
  # Broken meson with Darwin. Should hopefully be fixed soon. Tracking
  # in https://bugzilla.gnome.org/show_bug.cgi?id=781148.
  ++ lib.optionals (!stdenv.isDarwin) [ meson ninja ];

  # On Darwin, we currently use autoconf, on all other systems Meson
  # TODO Switch to Meson on Darwin as well

  # TODO How to pass these to Meson?
  configureFlags = lib.optionals stdenv.isDarwin [
    "--enable-x11=${if enableX11 then "yes" else "no"}"
    "--enable-wayland=${if enableWayland then "yes" else "no"}"
    "--enable-cocoa=${if enableCocoa then "yes" else "no"}"
  ]
  # Introspection fails on my MacBook currently
  ++ lib.optional stdenv.isDarwin "--disable-introspection";

  mesonFlags = lib.optionals (!stdenv.isDarwin) [
    # Enables all features, so that we know when new dependencies are necessary.
    "-Dauto_features=enabled"
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
    "-Dgl-graphene=disabled" # not packaged in nixpkgs as of writing
    # See https://github.com/GStreamer/gst-plugins-base/blob/d64a4b7a69c3462851ff4dcfa97cc6f94cd64aef/meson_options.txt#L15 for a list of choices
    "-Dgl_winsys=[${lib.concatStringsSep "," (lib.optional enableX11 "x11" ++ lib.optional enableWayland "wayland" ++ lib.optional enableCocoa "cocoa")}]"
  ]
  ++ lib.optional (!enableX11) "-Dx11=disabled"
  # TODO How to disable Wayland?
  ++ lib.optional (!enableAlsa) "-Dalsa=disabled"
  ++ lib.optional (!enableCdparanoia) "-Dcdparanoia=disabled"
  ;

  buildInputs = [ orc libtheora libintl libopus isocodes libjpeg libvisual tremor ]
    ++ lib.optional enableAlsa alsaLib
    ++ lib.optionals enableX11 [ libXv pango ]
    ++ lib.optional enableWayland wayland
    ++ lib.optional enableCocoa darwin.apple_sdk.frameworks.Cocoa
    ++ lib.optional enableCdparanoia cdparanoia;

  propagatedBuildInputs = [ gstreamer ];

  postPatch = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;

  doCheck = false; # fails, wants DRI access for OpenGL

  patches = [
    ./fix_pkgconfig_includedir.patch
  ];
}
