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
  pname = "gst-plugins-base";
  version = "1.16.0";

  meta = with lib; {
    description = "Base plugins and helper libraries";
    homepage = https://gstreamer.freedesktop.org;
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewbauer ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-base/${pname}-${version}.tar.xz";
    sha256 = "1bmmdwbyy89ayb85xc48y217f6wdmpz96f30zm6v53z2a5xsm4s0";
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
    # We must currently disable gtk_doc API docs generation,
    # because it is not compatible with some features being disabled.
    # See for example
    #     https://gitlab.gnome.org/GNOME/gnome-build-meta/issues/38
    # for it failing because some Wayland symbols are missing.
    # This problem appeared between 1.15.1 and 1.16.0.
    "-Dgtk_doc=disabled"
  ]
  ++ lib.optional (!enableX11) "-Dx11=disabled"
  # TODO How to disable Wayland?
  ++ lib.optional (!enableAlsa) "-Dalsa=disabled"
  ++ lib.optional (!enableCdparanoia) "-Dcdparanoia=disabled"
  ;

  buildInputs = [ orc libtheora libintl libopus isocodes libjpeg tremor ]
    ++ lib.optional (!stdenv.isDarwin) libvisual
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
