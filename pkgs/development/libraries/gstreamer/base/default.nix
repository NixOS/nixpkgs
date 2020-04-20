{ stdenv
, fetchurl
, lib
, pkgconfig
, meson
, ninja
, gettext
, gobject-introspection
, python3
, gstreamer
, orc
, pango
, libtheora
, libintl
, libopus
, isocodes
, libjpeg
, libpng
, libvisual
, tremor # provides 'virbisidec'
, libGL
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_43
, enableX11 ? stdenv.isLinux
, libXv
, enableWayland ? stdenv.isLinux
, wayland
, wayland-protocols
, enableAlsa ? stdenv.isLinux
, alsaLib
# Enabling Cocoa seems to currently not work, giving compile
# errors. Suspected is that a newer version than clang
# is needed than 5.0 but it is not clear.
, enableCocoa ? false
, darwin
, enableGl ? (enableX11 || enableWayland || enableCocoa)
, enableCdparanoia ? (!stdenv.isDarwin)
, cdparanoia
, glib
}:

stdenv.mkDerivation rec {
  pname = "gst-plugins-base";
  version = "1.16.2";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0sl1hxlyq46r02k7z70v09vx1gi4rcypqmzra9jid93lzvi76gmi";
  };

  patches = [
    ./fix_pkgconfig_includedir.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    python3
    gettext
    orc
    glib
    gobject-introspection

    # docs
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_43
  ] ++ lib.optional enableWayland wayland;

  buildInputs = [
    orc
    libtheora
    libintl
    libopus
    isocodes
    libpng
    libjpeg
    tremor
    libGL
  ] ++ lib.optional (!stdenv.isDarwin) [
    libvisual
  ] ++ lib.optionals stdenv.isDarwin [
    pango
    darwin.apple_sdk.frameworks.OpenGL
  ] ++ lib.optionals enableAlsa [
    alsaLib
  ] ++ lib.optionals enableX11 [
    libXv
    pango
  ] ++ lib.optionals enableWayland [
    wayland
    wayland-protocols
  ] ++ lib.optional enableCocoa darwin.apple_sdk.frameworks.Cocoa
    ++ lib.optional enableCdparanoia cdparanoia;

  propagatedBuildInputs = [
    gstreamer
  ];

  mesonFlags = [
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
    "-Dgl-graphene=disabled" # not packaged in nixpkgs as of writing
    # See https://github.com/GStreamer/gst-plugins-base/blob/d64a4b7a69c3462851ff4dcfa97cc6f94cd64aef/meson_options.txt#L15 for a list of choices
    "-Dgl_winsys=${lib.concatStringsSep "," (lib.optional enableX11 "x11" ++ lib.optional enableWayland "wayland" ++ lib.optional enableCocoa "cocoa")}"
    # We must currently disable gtk_doc API docs generation,
    # because it is not compatible with some features being disabled.
    # See for example
    #     https://gitlab.freedesktop.org/gstreamer/gst-plugins-base/issues/564
    # for it failing because some Wayland symbols are missing.
    # This problem appeared between 1.15.1 and 1.16.0.
    # In 1.18 they should switch to hotdoc, which should make this issue irrelevant.
    "-Dgtk_doc=disabled"
  ]
  ++ lib.optional (!enableX11) "-Dx11=disabled"
  # TODO How to disable Wayland?
  ++ lib.optional (!enableGl) "-Dgl=disabled"
  ++ lib.optional (!enableAlsa) "-Dalsa=disabled"
  ++ lib.optional (!enableCdparanoia) "-Dcdparanoia=disabled"
  ++ lib.optionals stdenv.isDarwin [
    "-Dlibvisual=disabled"
  ];

  postPatch = ''
    patchShebangs common/scangobj-merge.py
  '';

  # This package has some `_("string literal")` string formats
  # that trip up clang with format security enabled.
  hardeningDisable = [ "format" ];

  doCheck = false; # fails, wants DRI access for OpenGL

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

  meta = with lib; {
    description = "Base GStreamer plug-ins and helper libraries";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
