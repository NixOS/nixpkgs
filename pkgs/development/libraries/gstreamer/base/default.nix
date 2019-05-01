{ stdenv, fetchurl, fetchpatch, lib
, pkgconfig, meson, ninja, gettext, gobject-introspection
, python3, gstreamer, orc, pango, libtheora
, libintl, libopus
, isocodes
, libjpeg
, libpng
, libvisual
, tremor # provides 'virbisidec'
, gtk-doc, docbook_xsl, docbook_xml_dtd_412
, enableX11 ? stdenv.isLinux, libXv
, enableWayland ? stdenv.isLinux, wayland
, enableAlsa ? stdenv.isLinux, alsaLib
# Enabling Cocoa seems to currently not work, giving compile
# errors. Suspected is that a newer version than clang
# is needed than 5.0 but it is not clear.
, enableCocoa ? false
, darwin
, enableGl ? (enableX11 || enableWayland || enableCocoa)
, enableCdparanoia ? (!stdenv.isDarwin), cdparanoia }:

stdenv.mkDerivation rec {
  name = "gst-plugins-base-${version}";
  version = "1.16.0";

  meta = with lib; {
    description = "Base plugins and helper libraries";
    homepage = https://gstreamer.freedesktop.org;
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewbauer ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-base/${name}.tar.xz";
    sha256 = "1bmmdwbyy89ayb85xc48y217f6wdmpz96f30zm6v53z2a5xsm4s0";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkgconfig python3 gettext gobject-introspection
    meson
    ninja
    gtk-doc
    # Without these, enabling the 'gtk_doc' gives us `FAILED: meson-install`
    docbook_xsl docbook_xml_dtd_412
  ];

  mesonFlags = [
    # Enables all features, so that we know when new dependencies are necessary.
    "-Dauto_features=enabled"
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
    "-Dgl-graphene=disabled" # not packaged in nixpkgs as of writing
    "-Dgl_platform=[${lib.optionalString (enableX11 || enableWayland || enableCocoa) "auto"}]"
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
  ++ lib.optional (!enableGl) "-Dgl=disabled"
  ++ lib.optional (!enableAlsa) "-Dalsa=disabled"
  ++ lib.optional (!enableCdparanoia) "-Dcdparanoia=disabled"
  ++ lib.optionals stdenv.isDarwin [
    "-Dlibvisual=disabled"
  ]
  ;

  buildInputs = [ orc libtheora libintl libopus isocodes libjpeg libpng tremor ]
    ++ lib.optional enableAlsa alsaLib
    ++ lib.optionals (!stdenv.isDarwin) [
      libvisual
    ]
    ++ lib.optionals enableX11 [ libXv pango ]
    ++ lib.optionals stdenv.isDarwin [
      pango
      darwin.apple_sdk.frameworks.OpenGL
    ]
    ++ lib.optional enableWayland wayland
    ++ lib.optional enableCocoa darwin.apple_sdk.frameworks.Cocoa
    ++ lib.optional enableCdparanoia cdparanoia;

  propagatedBuildInputs = [ gstreamer ];

  postPatch = ''
    patchShebangs .
  '';

  # This package has some `_("string literal")` string formats
  # that trip up clang with format security enabled.
  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  doCheck = false; # fails, wants DRI access for OpenGL

  patches = [
    ./fix_pkgconfig_includedir.patch
  ];

  passthru = {
    # Downstream `gst-*` packages depending on `gst-plugins-base`
    # have meson build options like 'gl' etc. that depend
    # on these features being built in `-base`.
    # If they are not built here, then the downstream builds
    # will fail, as they, too, use `-Dauto_features=enabled`
    # which would enable these options unconditionally.
    # That means we must communicate to these downstream packages
    # if the `-base` enabled these options or not, so that
    # the can enable/disable those features accordingly.
    # The naming `*Enabled` vs `enable*` is intentional to
    # distinguish inputs from outputs (what is to be built
    # vs what was built) and to make them easier to search for.
    glEnabled = enableGl;
    waylandEnabled = enableWayland;
  };
}
